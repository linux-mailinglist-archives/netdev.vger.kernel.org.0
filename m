Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1073A19F915
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 17:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729002AbgDFPnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 11:43:43 -0400
Received: from mail-qv1-f67.google.com ([209.85.219.67]:42359 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728736AbgDFPnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 11:43:43 -0400
Received: by mail-qv1-f67.google.com with SMTP id ca9so131509qvb.9;
        Mon, 06 Apr 2020 08:43:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=GRKenN9BAw4cQ1954SZogV6YlC0w8kRJmJaT7yjp8xw=;
        b=OEAEJBg2TI5OIIHcPNEn7S/uBbfftx6RtsMNUOPvtpKqF8IBsS380YvIh44JVlNrOF
         7kFmLxzG1mfWLmtbVY2Q7OrGw7XWvCQGxgDpEhCcAbnojTTMX+WWn40Vh6R9Om6CpeAg
         YymyxlPtj3oKF+/nyPZCEKGFWjRExhexvOZKVMZUb7ytbtAcqDwUlKQoopyDxyD5K59r
         q7KN4Kt1wu1DLsjiGRhTZgCjdOnJASX55I25GQCzFMiDb6yBBErOxfP/jnc9qT8VlVuV
         akZb3ORgIjufoqWlkb8uMgF7cKMsK4Ooy0AcG+8hwec9UylJ4J3LxBui/0UnB+l2dZaU
         KNew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=GRKenN9BAw4cQ1954SZogV6YlC0w8kRJmJaT7yjp8xw=;
        b=jXT/J0HZVSpLOcwPMyW0Q7KdLrG7unuBut3akFfJ4MjQFVXHoC0p/Mk+hTdLOfCywH
         wwv2rymKA6mTxoR71D/GR+sgOBZuGju6b0fHBVvFBU+T3DJ2QYY5EZm972iFqDQlMI04
         0GxLfx213grttROaa7va3lPumSVpNkJICD4tSRc7zLyxDqcqr07AxhHcmTrM7XgdECfY
         hiea+T7m/ecyvKwnclpEg2hbZkb8ZIel4LMEgQPoXT/CNB2Ww24fMYB7E5z+Yqcw6Q7s
         RFIzsaUUt6800D2z5oQiJBtdELdO3dQSveuhPu+WKuxPaAstIPxY8la+Ig1YKt5VZRix
         bTNg==
X-Gm-Message-State: AGi0PuYSNtzVZYyBVNkB27SBQbsIvnQLst0aAUjjWcRz+5Gt/ARNDhv+
        nLjJ7XE0bzRXmX6Qui9GeV0=
X-Google-Smtp-Source: APiQypJT1ZJu7Ob/SoVGxdLNDv5XVRGI9xPT04ypY1V6GvkVmjpsEv+JDgTp3+LEHIL6+6YIUYctDg==
X-Received: by 2002:a0c:f806:: with SMTP id r6mr266562qvn.24.1586187822327;
        Mon, 06 Apr 2020 08:43:42 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id f1sm13857494qkl.72.2020.04.06.08.43.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 08:43:41 -0700 (PDT)
Date:   Mon, 6 Apr 2020 11:43:40 -0400
Message-ID: <20200406114340.GF510003@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: dsa: bcm_sf2: Ensure correct sub-node is parsed
In-Reply-To: <20200405200031.27263-1-f.fainelli@gmail.com>
References: <20200405200031.27263-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  5 Apr 2020 13:00:30 -0700, Florian Fainelli <f.fainelli@gmail.com> wrote:
> When the bcm_sf2 was converted into a proper platform device driver and
> used the new dsa_register_switch() interface, we would still be parsing
> the legacy DSA node that contained all the port information since the
> platform firmware has intentionally maintained backward and forward
> compatibility to client programs. Ensure that we do parse the correct
> node, which is "ports" per the revised DSA binding.
> 
> Fixes: d9338023fb8e ("net: dsa: bcm_sf2: Make it a real platform device driver")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
