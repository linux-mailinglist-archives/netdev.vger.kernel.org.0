Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73EC7633D69
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 14:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233705AbiKVNTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 08:19:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233501AbiKVNTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 08:19:24 -0500
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21E1D1B1ED;
        Tue, 22 Nov 2022 05:19:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=R807ln6AiqSe+3HbtFqvP+BN4yO/wv214XfFb1EqQbE=; b=Cp5ZsrWKUviJGN4iZ8ebliVHg8
        XrD6kI035Ghf8BzClosXhfrvpUT0ccJIjXAhcibCXTJJVHOmcjEudO8HrNxwxDY4LcOHn7GYCCtfk
        BC3tGylzbaNaAdZElIA5USHN/F2smve6g5ln8xoWhExRWWSnECmaNJNn+ElT/FOs/j98JrYfJoQ4i
        p9IDt8Vn7K7Ufj9PJMpWBR7alvG8NSJF0gLKedddixCXJ1DyxBrmrkjA3oP1kGou//EySNS1qoBRL
        qY1gtI7dbROFyTMfUVdD3j0ezj2gdIGyfpX9V4eRXtNgYm2yljfNkOazXccZrYxBNMqguPjyfQJH9
        nrm/6fsg==;
Received: from [177.102.6.147] (helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1oxTBH-006xGt-Ne; Tue, 22 Nov 2022 14:19:19 +0100
Message-ID: <c6b543d2-8569-7f7a-56fb-2f5899b6504c@igalia.com>
Date:   Tue, 22 Nov 2022 10:19:15 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH V3 02/11] notifier: Add panic notifiers info and purge
 trailing whitespaces
Content-Language: en-US
To:     akpm@linux-foundation.org
Cc:     kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        pmladek@suse.com, bhe@redhat.com, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, x86@kernel.org, kernel-dev@igalia.com,
        kernel@gpiccoli.net
References: <20220819221731.480795-1-gpiccoli@igalia.com>
 <20220819221731.480795-3-gpiccoli@igalia.com>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <20220819221731.480795-3-gpiccoli@igalia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/08/2022 19:17, Guilherme G. Piccoli wrote:
> Although many notifiers are mentioned in the comments, the panic
> notifiers infrastructure is not. Also, the file contains some
> trailing whitespaces. Fix both issues here.
> 
> Cc: Arjan van de Ven <arjan@linux.intel.com>
> Cc: Cong Wang <xiyou.wangcong@gmail.com>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: Valentin Schneider <valentin.schneider@arm.com>
> Cc: Xiaoming Ni <nixiaoming@huawei.com>
> Reviewed-by: Baoquan He <bhe@redhat.com>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
> 
> ---
> 
> V3:
> - Added Baoquan review tag - thanks!
> 
> V2:
> - No changes.
> 
> 

Hi Andrew, do you think it makes sense to merge this one for v6.2/next?
I don't see anything else required here, lemme know otherwise.

Thanks,


Guilherme


P.S. Trimmed a bit the huge CC list, but kept all MLs.
