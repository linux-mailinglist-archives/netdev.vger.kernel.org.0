Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF3AC1EB3
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 12:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730659AbfI3KJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 06:09:45 -0400
Received: from 3.mo173.mail-out.ovh.net ([46.105.34.1]:59131 "EHLO
        3.mo173.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727025AbfI3KJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 06:09:45 -0400
X-Greylist: delayed 6602 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Sep 2019 06:09:44 EDT
Received: from player759.ha.ovh.net (unknown [10.108.35.223])
        by mo173.mail-out.ovh.net (Postfix) with ESMTP id 7F75111B13D
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 09:41:22 +0200 (CEST)
Received: from RCM-web7.webmail.mail.ovh.net (gw.sk2.org [88.186.243.14])
        (Authenticated sender: steve@sk2.org)
        by player759.ha.ovh.net (Postfix) with ESMTPSA id E920FA660146;
        Mon, 30 Sep 2019 07:41:12 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Mon, 30 Sep 2019 09:41:12 +0200
From:   Stephen Kitt <steve@sk2.org>
To:     Song Liu <songliubraving@fb.com>
Cc:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH] bpf: use flexible array members, not zero-length
In-Reply-To: <F15E974F-4B7F-4819-B640-682A0A3A47C5@fb.com>
References: <20190928144814.27002-1-steve@sk2.org>
 <02a551bc-7551-7c0e-0215-5ac8856b0512@embeddedor.com>
 <F15E974F-4B7F-4819-B640-682A0A3A47C5@fb.com>
Message-ID: <fd62b14d7333864a612591bdf19f0603@sk2.org>
X-Sender: steve@sk2.org
User-Agent: Roundcube Webmail/1.3.10
X-Originating-IP: 88.186.243.14
X-Webmail-UserID: steve@sk2.org
X-Ovh-Tracer-Id: 12799793094767889791
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedufedrgedugdduvdefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 30/09/2019 08:07, Song Liu a écrit :
>> On Sep 28, 2019, at 10:49 PM, Gustavo A. R. Silva 
>> <gustavo@embeddedor.com> wrote:
>> I think you should preserve the tab here.
> 
> Agreed.

Indeed (and I thought I’d checked whitespace changes!). V2 upcoming with 
an improved Coccinelle script which preserves whitespace and fixes a 
couple of other issues which appear in other files (attributes, and 
structs defined alongside the field declaration).

> Besides this:
> 
> Acked-by: Song Liu <songliubraving@fb.com>

Thanks!

Regards,

Stephen
