Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C50F16B6B6
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 01:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728529AbgBYA37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 19:29:59 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:38354 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727081AbgBYA37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 19:29:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=JVU4gdBDiIRvc9V2bP234i33D7WlgF36h67W5FUswC8=; b=fVyxcSFfRUcoaq6hF+R6vxlzKy
        YedSkscc6BX4kjz5eD1kKWvrnCmlFfk6nB6lyc5kZss7sZ32tBJXOGFmCMp1vQDouTTFnUAZ4Ea/L
        7gjUS6vT7+2+BugsI3ja5cMQV2GJQ/mbDldWA9WNVmK4yuuMdLi4Bs6ZkfJ9ZV68ny45i6k7Q02bh
        lgnPi4deJ6V5uwM+4qc27c0FaNCpqapbI3AY65u33Db2bAaoBKh5lGi6hhlOkwWq1S8qPq4uZ4S4o
        jx+G6dcBv54eIohv/5avVqvPSWNXXsrGpIOUSSpO2Cg0UvSAlAb/q4t0Xkz8F3HC4wADJPiwT0eH3
        q29y/3Sw==;
Received: from 96-90-213-161-static.hfc.comcastbusiness.net ([96.90.213.161] helo=[10.11.45.55])
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6O6o-0005VU-Dn; Tue, 25 Feb 2020 00:29:58 +0000
Subject: Re: [PATCH][next] toshiba: Replace zero-length array with
 flexible-array member
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        "David S. Miller" <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Ishizaki Kou <kou.ishizaki@toshiba.co.jp>
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
References: <20200224163252.GA28066@embeddedor>
From:   Geoff Levand <geoff@infradead.org>
Message-ID: <1989d527-06ad-832b-19c0-d8cabc6509e9@infradead.org>
Date:   Mon, 24 Feb 2020 16:29:57 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200224163252.GA28066@embeddedor>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/24/20 8:32 AM, Gustavo A. R. Silva wrote:
> The current codebase makes use of the zero-length array language
> extension to the C90 standard, but the preferred mechanism to declare
> variable-length types such as these ones is a flexible array member[1][2],
> introduced in C99:

Seems fine.

Acked-by: Geoff Levand <geoff@infradead.org>
