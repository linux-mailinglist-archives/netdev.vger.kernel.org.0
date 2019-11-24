Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F29ED108146
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 01:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbfKXAmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 19:42:49 -0500
Received: from mail-pj1-f42.google.com ([209.85.216.42]:38481 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbfKXAmt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 19:42:49 -0500
Received: by mail-pj1-f42.google.com with SMTP id f7so4795423pjw.5
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 16:42:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=+xL7v2lz0wKkvKpY/kg5MoS8Js989r/mJm70H8FChC4=;
        b=NlGv/P0J2Y8Uy/slHNSd5ChJP8Mu3obqANI4sTsrdP5+HELssDbGavXLmz0fajBnfq
         yoPmHgJ9oTstB84+EFvBPUmA2xJnx5sRprTLKEBJmO3TwffaL6fGLFVtPdnUFyKOiEKA
         LX4+/tZEtbyIkzCHU1QUV3803sk/8Lpfwt03dYrDx7tK0V8NGcHxD6cI9HMhrAqOoqRv
         hUcJTmjpgoXMdKgZuDKc8OtRvV1fpZlHyizEE8DuvBrOGCv1Ed3kMcCXwqfAei2jxUie
         iOcOl1qyltnGwEoKt1fC6A/A92Umaqwdy9HLBx6t0B6XRRH+35tWIf7p+3FjqVXd1z/4
         X1gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=+xL7v2lz0wKkvKpY/kg5MoS8Js989r/mJm70H8FChC4=;
        b=QvYfbmt7D/wGDwi8Jx73GHkNpMT4eZMfzXEaRXxtF4edSn57eV7MPMVZkXouYPQg5G
         LsdR8U318VSbQGmuwfOf9zpamt5tAX7gHhBXDc0DFqEGL8YH1Dudu18qmjPwNJi6dVEn
         z8abNaDzLfvHxJGe/c5ts2id21OERoRyrkS9rvO/kpNnyqkqu2B7ptqD192vs+8MloZ1
         FDIz9u67M/1LFmB8z+BUfYm+c7rEuPlOaxriZcdQCGxZ5XbMwpWRhToUqYlGiZPx5nY0
         qCqKzqH85JBxMo0E4e3v3s/eeix7VjLApe+cPtY89NUho/SyBMC1GS8xnVhpS97nWPH/
         L2jA==
X-Gm-Message-State: APjAAAWn9I1pwoFtkyh5gitOdTvcUCcRZfMp6imE5XSSLZngHlG57bNY
        kNcgS691N4ZhP5/NNf9noMMvMhoDfdM=
X-Google-Smtp-Source: APXvYqwSN9lcDqFvpBGSB9q2g+cL5woeL72658ldH8Pb2uLm92sC/4pLBaP3CvYvPg5Gm3BZyBTDMA==
X-Received: by 2002:a17:902:8303:: with SMTP id bd3mr18848204plb.181.1574556168701;
        Sat, 23 Nov 2019 16:42:48 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id f35sm2969203pje.32.2019.11.23.16.42.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 16:42:48 -0800 (PST)
Date:   Sat, 23 Nov 2019 16:42:44 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [pull request][net-next 0/6] Mellanox, mlx5 updates 2019-11-22
Message-ID: <20191123164244.0518fc5f@cakuba.netronome.com>
In-Reply-To: <20191122212541.17715-1-saeedm@mellanox.com>
References: <20191122212541.17715-1-saeedm@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Nov 2019 21:26:47 +0000, Saeed Mahameed wrote:
> Hi Dave,
> 
> This small series adds misc updates to mlx5 driver.
> 
> For more information please see tag log below.
> 
> Please pull and let me know if there is any problem.

Pulled, thanks, but you have a duplicate sign-off on patch 5 and since
this is a pull I couldn't remove it. Please double check in the future.
