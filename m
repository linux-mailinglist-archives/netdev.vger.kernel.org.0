Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C20E4D8146
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 22:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389333AbfJOUpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 16:45:33 -0400
Received: from mail-lj1-f179.google.com ([209.85.208.179]:33521 "EHLO
        mail-lj1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388069AbfJOUpd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 16:45:33 -0400
Received: by mail-lj1-f179.google.com with SMTP id a22so21696944ljd.0
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 13:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=3sTI7HF1pEOo9uiGgFvCLpEQtHEUcjkhgN7IuFOAUTo=;
        b=Hd+7SGm8x8BT34f8apHzWlku6NkNxOFJM56duBhkQehJ3ePR/6RPNrnZu7wf49xT8q
         cWuN0gzIodBfzLAls5CmJT/V2IDKGzq4mVX76lFsmIGkc0XtDDsI34JGiQTcAWJ8ZMkX
         41fmchwWLmFF225RuZZklSP2cd1KFJWU8eG4VvWYOgXM69VNPLGI3jbIdb/3mp80JVJd
         PuJmfjwl433FFqLFXtD3EqS4M5b3CLjsmKEGq0Dk73bQ8/GDVFZRp1uqvjJn1fG6Jb8N
         rhaBunmIyJbc23bnVgMvjh7tWHNJeoJZQ32BJZsWDqmzGw1bLnzd+BJSxbJO/+evPwIK
         yH2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=3sTI7HF1pEOo9uiGgFvCLpEQtHEUcjkhgN7IuFOAUTo=;
        b=NDJwiwCypEDNfFRTzEQTOTEl3IMX7OrqnjWiu4pDO0QCoBmEz7Es70971pnpvhiPBr
         27csxhsfKRh7J4/9+yWQbSExb701hfVemzIArbL+hJuhRlibMyjVBDsTfsfLww9N7Itf
         T1AFeRnNs8lFS0ehgKZrmGuAzLXy3h6O8FM0EuNNWFb82/ki/WabR39AgQjSKI8oMGpd
         p6V1ValHK9PebA1q6uZRr67sqVzxT5QLekS16EEu0JCgQtmYAD0M1EY9v7MKn5kSYA5P
         oKicHWcPBnSgODOa8W9KjoxCoo8wzjn08roG6RUTZTCN4zFkxzilpjuaZtRVcMiWa3xl
         VUfA==
X-Gm-Message-State: APjAAAXhLq71MfLSF5TvyBBmYwm0aZSlJf9bKNaQyqyus54lRMWOE4dk
        /GBsC1ig8LAGB8o7sq42Jh+bXQ==
X-Google-Smtp-Source: APXvYqxYNHNpfzL6TjfXNghWlhSONFfYYxQgIwt0ch2NaL1I+PtJ1ikUxvUMpXqf7SxoWsnJETD17A==
X-Received: by 2002:a2e:95d9:: with SMTP id y25mr23999735ljh.217.1571172331121;
        Tue, 15 Oct 2019 13:45:31 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id a14sm5460997lfg.74.2019.10.15.13.45.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2019 13:45:30 -0700 (PDT)
Date:   Tue, 15 Oct 2019 13:45:22 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, mlxsw@mellanox.com
Subject: Re: [patch net-next v2 0/2] mlxsw: Add support for 400Gbps (50Gbps
 per lane) link modes
Message-ID: <20191015134522.6002d501@cakuba.netronome.com>
In-Reply-To: <20191015201416.GA2266@nanopsycho>
References: <20191012162758.32473-1-jiri@resnulli.us>
        <20191015120757.12c9c95b@cakuba.netronome.com>
        <20191015201416.GA2266@nanopsycho>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Oct 2019 22:14:16 +0200, Jiri Pirko wrote:
> Tue, Oct 15, 2019 at 09:07:57PM CEST, jakub.kicinski@netronome.com wrote:
> >On Sat, 12 Oct 2019 18:27:56 +0200, Jiri Pirko wrote:  
> >> From: Jiri Pirko <jiri@mellanox.com>
> >> 
> >> Add 400Gbps bits to ethtool and introduce support in mlxsw. These modes
> >> are supported by the Spectrum-2 switch ASIC.  
> >
> >Thanks for the update, looks good to me!
> >
> >Out of curiosity - why did we start bunching up LR, ER and FR?  
> 
> No clue. But it's been done like that for other speeds too.

Looks like for 50G Serdeses and 4x25G we started grouping by Clause.
Probably makes sense.
