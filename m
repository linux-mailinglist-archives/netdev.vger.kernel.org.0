Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34B5D12580B
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 00:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbfLRXx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 18:53:58 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44974 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfLRXx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 18:53:58 -0500
Received: by mail-pg1-f195.google.com with SMTP id x7so2102878pgl.11
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 15:53:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=7Q7+ngoxGHulcvPYWZfpmuI44mIQd4qNwFvocQ6UeyE=;
        b=vHwWJMgadN5EiuG0ZoK3Dz8PBDovBTvVOhUIDn/IekItG+R5GBJZ9U74qfxDIs3MtY
         4F7G7skWYb26dN4wjLMny/l7/T7YJmmtsTquDzQS4gFKUMdzOucbhYZ1sdW4Y3A/I1VH
         3ojtwGfm2rvXD3E3fdzaCAboSGaDMAgR3CF/RQlTCne7sHQxzOv5RLvT5UDoEq821UNt
         kikMbjOyVCnCDrpmO4xiRO80tjOf2p9gsDeoLMzVn738xaAbmym/2927YhIeSrOmKEOk
         hxeFnYBTd1WON4Fx5htXcYa0a09oOdvJ+me5z+VmN+SvY/Ot1b2qdY94qWXYrcJyKG1I
         6prg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=7Q7+ngoxGHulcvPYWZfpmuI44mIQd4qNwFvocQ6UeyE=;
        b=gDrb3dz03k4DJafUedHEoW/++fN9t1PUHic0/uVA1UgwbJsM3/dZpOaVgpvLoYgLJM
         VYeRF2xR3HbOm0At0hPx8S6tiGjBuGrW86Tpv5DzhpZBhlAl27N41+UxOT4FClEo7u8d
         /khiKyzTGrWZZ1QFPdGsfbeQXxOIfVCwDpOybJdC8mfXV+dBtwm4qgjpMtUCzd3XHPFi
         I/+/wgnbCdCcD4yCIM+uOV5IWsP0W2/dlZUBySiP92xpMLpkcI9mWXFqyY6RpHAgcf+y
         cd4j0mvHSLr95gLgxgl1R4QAtYycVhBtF+ueLXN0sgM2ZEzGzoyyi1dXTW7q2IatxHiJ
         GI4Q==
X-Gm-Message-State: APjAAAUaE//gCTuIVQMMDZgOr/P62acBlWUE+gj/J697oP3XG7LoIQ+O
        vkmuzgjrpQ31OzGWf3EOUmeijL/e67I=
X-Google-Smtp-Source: APXvYqwKg3JkOYHR38ux4hW6JP9eTNleJfh4Oab9ocDpoo7p3hgNWPBUCizuAiXclupj3Q8e6pliBQ==
X-Received: by 2002:a62:754b:: with SMTP id q72mr5241346pfc.102.1576713237437;
        Wed, 18 Dec 2019 15:53:57 -0800 (PST)
Received: from cakuba.netronome.com ([216.9.110.3])
        by smtp.gmail.com with ESMTPSA id e10sm4991277pfm.3.2019.12.18.15.53.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 15:53:57 -0800 (PST)
Date:   Wed, 18 Dec 2019 15:52:05 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     ldir@darbyshire-bryant.me.uk, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] sch_cake: drop unused variable
 tin_quantum_prio
Message-ID: <20191218155205.6b0d724c@cakuba.netronome.com>
In-Reply-To: <20191218.123716.1806707418521871245.davem@davemloft.net>
References: <20191218140459.24992-1-ldir@darbyshire-bryant.me.uk>
        <20191218095340.7a26e391@cakuba.netronome.com>
        <20191218.123716.1806707418521871245.davem@davemloft.net>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Dec 2019 12:37:16 -0800 (PST), David Miller wrote:
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Date: Wed, 18 Dec 2019 09:53:40 -0800
> 
> > On Wed, 18 Dec 2019 14:05:13 +0000, Kevin 'ldir' Darbyshire-Bryant
> > wrote:  
> >> Turns out tin_quantum_prio isn't used anymore and is a leftover from a
> >> previous implementation of diffserv tins.  Since the variable isn't used
> >> in any calculations it can be eliminated.
> >> 
> >> Drop variable and places where it was set.  Rename remaining variable
> >> and consolidate naming of intermediate variables that set it.
> >> 
> >> Signed-off-by: Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>  
> > 
> > Checkpatch sayeth:
> > 
> > WARNING: Missing Signed-off-by: line by nominal patch author 'Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>'  
> 
> Which is kinda rediculous wouldn't you say? :-)
> 
> The warning stops to be useful if it's going to be applied in situations
> like this where merely a nickname 'ldir' is added to the middle of the
> person's formal name.
> 
> I would never push back on a patch on these grounds, it just wastes time.

Yup, just tuning the checks, this one I wasn't 100% sure :-)

Looks like Greg's script only complains if both name and address are
different, but checkpatch expects the exact same thing. I'll stick to
Greg's method.

Feedback is very welcome :-)
