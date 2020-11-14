Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 890712B2A49
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 02:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbgKNBEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 20:04:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbgKNBEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 20:04:39 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD6AAC0613D1
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 17:04:38 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id s25so16401294ejy.6
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 17:04:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fS1QDgsr2H+tGEwQyKF/bMU/tQa5wqQ0pKujW6HYKVM=;
        b=ewv3mJoQbvNs8LZqToDy0aCfGsKHAJ7UmXlHSplFYKHrJGtPJ7QpTF68wNr0o6VoQa
         1OCU9mAl5dXXDmi9CXfgiD/mQbeUMu+QKNfAmlrKRqzPD80lSd8sFVrNcNDT4XxAQR0Z
         Zq8XMfENE1go8gdQvThFh3I6y4Uz25Go/MvN3vn1cBMHJ19BN5i+PkrcBb1WWD5+wtsa
         FIzyN1ozPbRWNs4zw2jDMdPHS28PE4de8AOKDjh6D/h8nUkSgHHFPf9/Km3ZGoFbgrcl
         +1XngoqQOIA9h4296Hskh1XFA5D4N22N6zuwxoCeakBBb1as/dvSfJQZGO+wIGmSHiVq
         Iq1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fS1QDgsr2H+tGEwQyKF/bMU/tQa5wqQ0pKujW6HYKVM=;
        b=j4RjAU5N+RM/RUb5QKiGjO05Jgrc3NcmU2s50U22akw+dSi7J+sGhCwDaZuiPW3P2c
         cm53RmRhvEH0zuDToo8faUzsAXG7+Q5Zf4GbtqS3ZW61C/4afBNR+1U/7CsmqrR0d2BB
         yMxYGfxc2MSZYLZL51aOPTvRC0kfOwyvzhJyQL0zJ1lEUBiEcfvkD1CJFrOH10oLijfA
         UGa0CEvg1bVBnvVE9EL6L5cH/LFIVXxl2ExDLveeFEZa99GEniRTzoi+pb4lg2W5hjjz
         aP+aMi5rNKimfUqo4LsYOmiWuW3WURxa1b1MRR8a+o/62MdqIcSks46ne5RQtwtBlMqH
         bWaQ==
X-Gm-Message-State: AOAM531EszwqyznMc/Cw6Z87zFsyTTKgFJMasMIRKCzR3e6hrodvQ/Dj
        4AeRDMTM46H/ISqt1vuTvFU=
X-Google-Smtp-Source: ABdhPJy8kFS+upBeHsBCgp/FC5PYmRlIII0djL2Xb0E2T/XpCmexiVl64/pEctF2G/DAM3k34HLusw==
X-Received: by 2002:a17:906:f10e:: with SMTP id gv14mr4674693ejb.346.1605315877606;
        Fri, 13 Nov 2020 17:04:37 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id sa23sm5005128ejb.80.2020.11.13.17.04.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 17:04:37 -0800 (PST)
Date:   Sat, 14 Nov 2020 03:04:36 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 2/2] net: dsa: tag_dsa: Use a consistent
 comment style
Message-ID: <20201114010436.l25ms23jxebffg3l@skbuf>
References: <20201111131153.3816-1-tobias@waldekranz.com>
 <20201111131153.3816-3-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201111131153.3816-3-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 02:11:53PM +0100, Tobias Waldekranz wrote:
> Use a consistent style of one-line/multi-line comments throughout the
> file.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
