Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43BD8FE02A
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 15:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727690AbfKOOd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 09:33:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:50026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727526AbfKOOd4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Nov 2019 09:33:56 -0500
Received: from [192.168.1.20] (cpe-24-28-70-126.austin.res.rr.com [24.28.70.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E6E620733;
        Fri, 15 Nov 2019 14:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573828435;
        bh=mF87Nl6gED2r2qJHxN4WWU1Jb6PLM4yh2d+dwZW5Hk8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Vvc8P1N2l/zeirxvFEhap3H1A3jDhl2uKzyj33rEKW2rwdgj5T8pzOsDy4fw1UWub
         XOWWlOSXPH1wP5r87NRbpax/A2wzVHEpPawa5nMHZ+KwvkJODp0QrvuDT4Y1ONRqcu
         eG/BLYr6FtmyUe4Co3Y8nzyrcQUTocfk9sbUsS/M=
Subject: Re: [PATCH v4 45/47] net/wan/fsl_ucc_hdlc: reject muram offsets above
 64K
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     Qiang Zhao <qiang.zhao@nxp.com>, Li Yang <leoyang.li@nxp.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Scott Wood <oss@buserror.net>, netdev <netdev@vger.kernel.org>
References: <20191108130123.6839-1-linux@rasmusvillemoes.dk>
 <20191108130123.6839-46-linux@rasmusvillemoes.dk>
 <CAOZdJXUibQ6RM8O4CfkYBdGsg+LMcE2ZoZEQ4txn2yvquUWwCA@mail.gmail.com>
 <79101f00-e3ff-9dd0-7a05-760f8be1ff69@rasmusvillemoes.dk>
From:   Timur Tabi <timur@kernel.org>
Message-ID: <3db19b28-90a4-f204-07b3-517cfd44010b@kernel.org>
Date:   Fri, 15 Nov 2019 08:33:52 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <79101f00-e3ff-9dd0-7a05-760f8be1ff69@rasmusvillemoes.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/15/19 1:44 AM, Rasmus Villemoes wrote:
> I can change it, sure, but it's a matter of taste. To me the above asks
> "does the value change when it is truncated to a u16" which makes
> perfect sense when the value is next used with iowrite16be(). Using a
> comparison to U16_MAX takes more brain cycles for me, because I have to
> think whether it should be > or >=, and are there some
> signedness/integer promotion business interfering with that test.

Ok.
