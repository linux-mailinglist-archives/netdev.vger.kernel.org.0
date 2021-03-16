Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAB2133E16F
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 23:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbhCPWbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 18:31:43 -0400
Received: from mout01.posteo.de ([185.67.36.65]:54252 "EHLO mout01.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231261AbhCPWbS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 18:31:18 -0400
Received: from submission (posteo.de [89.146.220.130]) 
        by mout01.posteo.de (Postfix) with ESMTPS id AFAEA16005C
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 23:31:14 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
        t=1615933874; bh=Vo4/JEKR9o3LdbZOlpjjMR/lYfv+Hf+rKvkB0CrMAE4=;
        h=Date:From:To:Cc:Subject:From;
        b=es6AcNt5ZHKysApQ0uqUVcaeeX88JlXjSNor4Y784YiVEbERFhr09dncIP1CCIfzC
         mj0/qshdkbwmtGLyC1kK+8iA5KQniAYlz4Kg+VpRQBkKBZaIm4C1Q/U7A9SE/f+jNd
         DOw+1PcbGes5Zdb/iG5It4am+NEl/NCI2EQP5kRrSkaLZJyD9eT81N+/nf44JQQHkf
         eoXyw+c95gB1YyYkzOzy0oF4xhT2PkjoICtUFQO19Zn/7ySqB8PUe4274NKuruXu0M
         JlA+nGvr3bruPeS4oNz9GUh5vm0uZuDoApUI09QS3KOVPZFRF5m7Jacv4Eu5Uuupz9
         Wqfh3wclLi6BA==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4F0SgN6ycNz9rxN;
        Tue, 16 Mar 2021 23:31:12 +0100 (CET)
Date:   Wed, 17 Mar 2021 09:31:10 +1100
From:   Tim Rice <trice@posteo.net>
To:     Petr Machata <petrm@nvidia.com>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Subject: Re: [BUG] Iproute2 batch-mode fails to bring up veth
Message-ID: <YFExrjo7jAZBzPuL@sleipnir.acausal.realm>
References: <YE+z4GCI5opvNO2D@sleipnir.acausal.realm>
 <YFBuv83HJLG0zMbw@shredder.lan>
 <87h7lbgxv1.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <87h7lbgxv1.fsf@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Petr,

>Thanks for the report. Would you be able to test with the following
>patch?
>
>    https://github.com/pmachata/iproute2/commit/a12eeca9caf90b3ebe24bc121819d506c9072a34.patch
>
>I believe it fixes the issue.

Awesome! That does fix it, thanks :)

~ Tim
