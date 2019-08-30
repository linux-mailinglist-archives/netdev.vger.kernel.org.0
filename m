Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B641AA4088
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 00:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728376AbfH3WYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 18:24:46 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:32961 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728164AbfH3WYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 18:24:46 -0400
Received: by mail-pf1-f194.google.com with SMTP id q10so427823pfl.0
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 15:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=8nJNIw1rQ/begFXvmg+y4YkAC0VdHZtvjD7Fjrjf2zM=;
        b=m9nPha85yg0s2kRzSI49gnOj/QZY6lZTlIElqe/GMV7N8JWFLlkK78aPaNj3By+Z7o
         XvMY1Fj8IRC2v8FYPJuzGqgaH9APSes2UCpGHZGO43KivWn1qcKMT/eDf9r28fhcG/AU
         GubSvXvwW/wqWb+pu1gTJhkFl1Hr+T01L0H98lDeXS61yPQiXNxcdNqGSZPBoOgH+f/K
         2yFUF9PYFlPEklGKoQ9don0EKrA3DPTwoqzdJ/fms8CEyRCIPG713W//6T7cF3XOAGX4
         xaFHX8kDJe1ALdrAw0y8zgJwoS68L3Mui5mw0JVN11ECtQVv4DOfUf9JCjDRt7tIge84
         7OsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=8nJNIw1rQ/begFXvmg+y4YkAC0VdHZtvjD7Fjrjf2zM=;
        b=IKo6l+p3xV3Gfu2XyRQP6lGawfjXkDq5CVIgseXD2DOMTaWRK96u96t2gVQUYg7jyx
         HMlWt3/HHCM3cNbTodiBmB3pjDrFYCQHmKBB2NRNhDZy4F/mc23TN0/2qdOLO9/AvCQ8
         A8LhCGURcFxvargsdpK4kdRcv+TQdarreoeGkHchFhlrKIgO+GFTbDIedcujBXLHDY9Q
         nwVunCopE/ZwCG7EilWB5T6aLvOMyEnt+wq90b/Zsu4MGFVAKOnSNvrfajV7XNjn9l+v
         5Uwu3NlWvE/TvBMmVDtc7m0wWkQXLA+h2UbFqtXocMRH7d9mGUImZaniooLw98RuLKYQ
         y2eQ==
X-Gm-Message-State: APjAAAWf+Rxb9C2m//6jgg19/fAm4Ih4fM3FMQs+HimVOsY+OsvkkyEa
        pBK4SWk/lbPryIYnHGWJcdE5hD1Sfy4=
X-Google-Smtp-Source: APXvYqzpBmwtuc6zdtnbEnKiDHmqpydUEi1Y+rXB5mN19fjKmuwocPTJHox7sFKVPPynKKlLEL/JQQ==
X-Received: by 2002:a63:40a:: with SMTP id 10mr15007103pge.317.1567203885655;
        Fri, 30 Aug 2019 15:24:45 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g23sm7806360pfo.2.2019.08.30.15.24.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2019 15:24:45 -0700 (PDT)
Date:   Fri, 30 Aug 2019 15:24:22 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v6 net-next 16/19] ionic: Add netdev-event handling
Message-ID: <20190830152422.7787e71d@cakuba.netronome.com>
In-Reply-To: <336eacda-27ae-d513-7888-429e34e29b76@pensando.io>
References: <20190829182720.68419-1-snelson@pensando.io>
        <20190829182720.68419-17-snelson@pensando.io>
        <20190829163738.64e7fe42@cakuba.netronome.com>
        <336eacda-27ae-d513-7888-429e34e29b76@pensando.io>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Aug 2019 14:36:23 -0700, Shannon Nelson wrote:
> On 8/29/19 4:37 PM, Jakub Kicinski wrote:
> > On Thu, 29 Aug 2019 11:27:17 -0700, Shannon Nelson wrote:  
> >> When the netdev gets a new name from userland, pass that name
> >> down to the NIC for internal tracking.
> >>
> >> Signed-off-by: Shannon Nelson <snelson@pensando.io>  
> > There is a precedent in ACPI for telling the FW what OS is running but
> > how is the interface name useful for the firmware I can't really tell.  
> It is so we can correlate the host's interface name with the internal 
> port data for internal logging.

Okay.. honestly brings back too many bad memories of arguing with
engineers who spent their lives building middle boxes..

I just hope this won't spread.
