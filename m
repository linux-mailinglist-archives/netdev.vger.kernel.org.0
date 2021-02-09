Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57C9F3154E1
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 18:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233068AbhBIRUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 12:20:48 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:3975 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232986AbhBIRUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 12:20:48 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6022c4470001>; Tue, 09 Feb 2021 09:20:07 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 9 Feb
 2021 17:20:06 +0000
Received: from yaviefel (172.20.145.6) by DRHQMAIL107.nvidia.com (10.27.9.16)
 with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 9 Feb 2021 17:20:04
 +0000
References: <20210201233445.2044327-1-jianyang.kernel@gmail.com>
 <87czx978x8.fsf@nvidia.com>
 <20210209082326.44dc3269@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Petr Machata <petrm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Petr Machata <petrm@nvidia.com>,
        Jian Yang <jianyang.kernel@gmail.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, Mahesh Bandewar <maheshb@google.com>,
        Jian Yang <jianyang@google.com>
Subject: Re: [PATCH net-next v3] net-loopback: set lo dev initial state to UP
In-Reply-To: <20210209082326.44dc3269@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Tue, 9 Feb 2021 18:19:59 +0100
Message-ID: <87pn195fb4.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612891207; bh=l0P3sCu7bRYxlcV1O7H2s8qSgyb5cXUG+i+AlfB3lWA=;
        h=References:User-agent:From:To:CC:Subject:In-Reply-To:Date:
         Message-ID:MIME-Version:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=VYYapDdfHtytWcQZE8/MnpxrCZslcSJl50khmilbpEKRuLylpKC2amghhnBQHHIlL
         YyL8vL5offf7U8hbcfNekepx6W2SXYVXaR61Vv/ORRTKQBz/qnTJFc1TuudU1MCsB0
         eq2Mq/SRHRoDIFceAUeQn0a7r/81KgIykDUDLztVSewQOn4Hbp58zyPv62I0dQT0hu
         aw9I6B/o5fqCbxpK1EN5x4f7IIbx85a5c3FJn+6i2h6DElc71wOJpohlcd6rHA3C2B
         rWSTbxatKp5m094zpWA8kJsW8b0EzTCDsGBmv+tD3puh80jK4agzkGiFpqfzr9bsEe
         Xf+2kFlgT5H/w==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jakub Kicinski <kuba@kernel.org> writes:

> Thanks for the report, could you send a revert with this explanation?

Sure.
