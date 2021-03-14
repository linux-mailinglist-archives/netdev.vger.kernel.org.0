Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 770EB33A451
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 12:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235232AbhCNLEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 07:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234362AbhCNLES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 07:04:18 -0400
Received: from mail.unsolicited.net (mail.unsolicited.net [IPv6:2001:8b0:15df::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ECA5C061574;
        Sun, 14 Mar 2021 04:04:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=unsolicited.net; s=one; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=TjZMP5Mn3p2KwflYYbDMq1xZGesmFxgoI1/hEdVvwu0=; b=qrl7EC39xsOmlBA0V42R96FKRC
        6zaUvDjJKKpkYS2lm5ELrsMTg/syP21fLIFkYr97xzGkyz3XgEPlWMJQs9ftLs+626xdp0OhpRQ3m
        8XhRGM5OpL7VWP+WlvNwVHBi0dgagXIwNyIE9mN3AcV9/1CGrb02tgEt4LgFz0F59W/Pdwm2cvrY5
        dTx38uhNS7G2pth4cQOvI8w0geO+u+3Opk6V/6ltFax3s3zeDINNJ69o0FH9jE+Mm82EmEatBWrWy
        h6wBs36zoLj1QTd0jJ53ziq/xzuV4dlVdZNa1ds0HioBfBeHlU6BQ5Upz2tUAj9aIscz3RghrjY7w
        6R3MfyGA==;
Subject: Re: Panic after upgrading to 5.11.6 stable
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
References: <dfd0563b-91da-87ab-0cfa-c1b99c659212@unsolicited.net>
 <20210314105301.GA27784@salvia>
From:   David R <david@unsolicited.net>
Autocrypt: addr=david@unsolicited.net; prefer-encrypt=mutual; keydata=
 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
Message-ID: <0ab51ec1-88cd-0c36-be9b-44c2d9311d9d@unsolicited.net>
Date:   Sun, 14 Mar 2021 11:04:14 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20210314105301.GA27784@salvia>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/03/2021 10:53, Pablo Neira Ayuso wrote:
> On Sun, Mar 14, 2021 at 10:30:55AM +0000, David R wrote:
>> I attempted to upgrade my home server to 5.11 today. The system panics
>> soon after boot with the following :-
>>
>> In iptables by the looks of the stack.
>>
>> 5.10.23 works fine.
>>
>> Can provide config (and boot logs from 5.10.23) if required.
> Please have a look at:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=211911
Looks like I upgraded just before a fix is merged. Just my luck.

Thanks for replying anyway!

David
