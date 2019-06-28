Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB5185A51B
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 21:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbfF1TYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 15:24:46 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:40320 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726695AbfF1TYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 15:24:46 -0400
Received: by mail-qt1-f193.google.com with SMTP id a15so7583249qtn.7
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 12:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=cCzj6qKrN803a9643E+5Md2gCX79M7QKv/xFnYJn48M=;
        b=iavrsC095EE16D8NevemOdGZl6FgCOIYU5M39EIjFf8VBj5kMxwofxDNJNqq9yOEOA
         TZRN1GlHB9fZAZ34ztYaGjBZeuyhf8Rp1GSrjJyvA52C/mTXGy4T8IlvB/gmPQTynzgO
         z/eMLfchWWPhT2EDYx+v0zq78xPEQI0AeJed/rEgxxCGD0bEVa9UeQTguMhXlaAPBdLE
         qkTocor/8WI1IyuCmZ05z/lljZXjqrjsa/wnxpscjvxwg2Qau6K3+FR0hkyG4dw1IWiv
         Z6cul3SoKT9UoWn3dmzaB8GcdGBcw9e7wHwZRjwm3Gh3d28Ztf4nV0j6ASLJKDOzatt4
         nXmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=cCzj6qKrN803a9643E+5Md2gCX79M7QKv/xFnYJn48M=;
        b=luKb1k3JygcdLXcxYbgnEUpK6o31DB8LQ0Wbf8vUqggObdqZW+v9mml4MnsR/C+49Y
         4167Wt2UKWK5C2qD7I6E+FBJAv5x0VGlMIGBu4WgjLBlNHkiK4Q+3C9vbYkCl97P7I9C
         YFD/ez1Ls1JI8cIAb7slhH0ZiR1R/8artlQrW8FNS2U+8JtHcoZglWHEW4uuFH9pmg5z
         a4pbTizeolfzMMuY6bvI/TOJ8DpsYPiIy0v/0rGedpUk4uMk70DMVu0uZ4120/A4HfW9
         hehrRMpfw7ihLJ6XPOJe8b5RJZDZKnHLbEuoIsYzGIlwiQentGynbEQsGtaFN2d7oyph
         YBAw==
X-Gm-Message-State: APjAAAUdnXTGkRI9GvV3t0RoRKQFHUEqg23CVovKvcfAykSsCM9lljzL
        1GtZapDcq/3LptKbnPCGYIA=
X-Google-Smtp-Source: APXvYqwJ5HRcosrciGS6efn2YrZjJoTE1u9YuKRJ3Svip2MjIY3xw2t8OE/E1LxXmQgVrYBWmo2JMQ==
X-Received: by 2002:a0c:bd9a:: with SMTP id n26mr9722902qvg.25.1561749885555;
        Fri, 28 Jun 2019 12:24:45 -0700 (PDT)
Received: from localhost ([24.48.76.248])
        by smtp.gmail.com with ESMTPSA id n3sm1331839qkk.54.2019.06.28.12.24.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 12:24:44 -0700 (PDT)
Date:   Fri, 28 Jun 2019 15:24:43 -0400
Message-ID: <20190628152443.GB2883@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Benedikt Spranger <b.spranger@linutronix.de>,
        netdev@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH 1/1] net: dsa: b53: Disable all ports on setup
In-Reply-To: <d5df00f5-599c-56ce-f93e-31587d16145a@gmail.com>
References: <20190628165811.30964-1-b.spranger@linutronix.de>
 <20190628165811.30964-2-b.spranger@linutronix.de>
 <d5df00f5-599c-56ce-f93e-31587d16145a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Jun 2019 10:23:06 -0700, Florian Fainelli <f.fainelli@gmail.com> wrote:
> On 6/28/19 9:58 AM, Benedikt Spranger wrote:
> > A b53 device may configured through an external EEPROM like the switch
> > device on the Lamobo R1 router board. The configuration of a port may
> > therefore differ from the reset configuration of the switch.
> > 
> > The switch configuration reported by the DSA subsystem is different until
> > the port is configured by DSA i.e. a port can be active, while the DSA
> > subsystem reports the port is inactive. Disable all ports and not only
> > the unused ones to put all ports into a well defined state.
> > 
> > Signed-off-by: Benedikt Spranger <b.spranger@linutronix.de>
> 
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> Makes sense, in fact, that should probably be moved to the DSA core at
> some point (wink wink Vivien).

On it!
