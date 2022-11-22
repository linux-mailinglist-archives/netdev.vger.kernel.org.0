Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96BD9633EF2
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 15:31:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233850AbiKVObB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 09:31:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233820AbiKVOa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 09:30:59 -0500
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87DFA6317F;
        Tue, 22 Nov 2022 06:30:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=hhxyfH2q8uH2ClLtYKVFoYmFg/Zqz1IeRGZh33Rp90E=; b=YIpI6ZN4aaZnSV4XS74JLfn2ab
        HwHXM0sCfl5jPn3JGZu9LGyE1gChqmkfjDnXjkwvTmD72Dl10QxGBN1KKWn2QYXfVX8OnX5/LNITc
        KkqrXNnID4YNPlv0JiMC/7W5QuHAhxvfoeNW5irbas9TNK+0rSskh5n54Yz3gxnkfT9nruRfyycHg
        Qh47Y7f844t2pXYbtTaTGiEj07T68UYcWn0buhcf0nL+KYiaGzLM8RZ7v4+nc26jfgKHQeZahBOYF
        9LXgTj3cfLKD9JnL4rkXnqK9zGUzzCaE1XSgkRjArb3Io3f86fBZFKJKqsqLC63T9Om7tF0uNY0NK
        H1qzHS5Q==;
Received: from [177.102.6.147] (helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1oxTIr-006xwh-AS; Tue, 22 Nov 2022 14:27:09 +0100
Message-ID: <960783ed-a8d1-6dd6-d4ac-7d2f28be9d54@igalia.com>
Date:   Tue, 22 Nov 2022 10:27:04 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH V3 06/11] tracing: Improve panic/die notifiers
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        x86@kernel.org, kernel-dev@igalia.com, kernel@gpiccoli.net,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Petr Mladek <pmladek@suse.com>
References: <20220819221731.480795-1-gpiccoli@igalia.com>
 <20220819221731.480795-7-gpiccoli@igalia.com>
 <20221020172908.25c6e3a5@gandalf.local.home>
 <6e2396d1-d0b2-0d1e-d146-f3ad7f2b39f8@igalia.com>
 <20221020182249.691bb82a@gandalf.local.home>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <20221020182249.691bb82a@gandalf.local.home>
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

On 20/10/2022 19:22, Steven Rostedt wrote:
> On Thu, 20 Oct 2022 18:53:43 -0300
> "Guilherme G. Piccoli" <gpiccoli@igalia.com> wrote:
> 
>> Could you pick it in your tree? Or do you prefer that I re-send as a
>> solo patch, with your ACK?
> 
> I wasn't sure there were any dependencies on this. If not, I can take it.
> 
> -- Steve

Hi Steve, I'm really sorry for the re-ping. Just wanted to know what's
the status here, not sure if you picked this one (checked
linux-trace/for-next, didn't see it there) or planning to.

Thanks in advance,


Guilherme


P.S. Trimmed huge CC list...
