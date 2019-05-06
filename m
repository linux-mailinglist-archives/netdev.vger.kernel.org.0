Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58E561464F
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 10:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbfEFI3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 04:29:39 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:39300 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726063AbfEFI3j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 04:29:39 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 64EC760DA8; Mon,  6 May 2019 08:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1557131378;
        bh=lrmi5R4AZI3gF9Ncy7xLnfPSXtgWNbQ9CagJI2qZ7+M=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=RHi4YtGwgHzqvCu1ud3ucO7u3R77mQCk2xODHPcoxrP+EQivknugVQHl94txl6ZYj
         iA3PWT4GL3s3SSJLCCSake0xAqfDP3JdU9HpI/sGMDwZFAbaLfth0USUE44DVOcdGG
         nYxSV8OYekuGBShow4V0xsIuk0Zbeq3M58uNfSLE=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED autolearn=no autolearn_force=no version=3.4.0
Received: from x230.qca.qualcomm.com (37-136-65-53.rev.dnainternet.fi [37.136.65.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9B6EF60CEC;
        Mon,  6 May 2019 08:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1557131377;
        bh=lrmi5R4AZI3gF9Ncy7xLnfPSXtgWNbQ9CagJI2qZ7+M=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=HFVHKT+4XIcM5qAVlIob4+mQjYOF3TYIfL91ASGWFwwOmpVk0FaEyD8+x0gGt76PP
         ag0S2s2j813Cv4M6mgOWspQG8EK1HG2TSOKM3XdrhYiGrKvz/g2wW4N4Yfvu0aDoIG
         dsk+g8E9MKv4NUN6yX3paB0P6hW0ksKlhDhtr25U=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9B6EF60CEC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     David Miller <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull-request: wireless-drivers 2019-04-30
References: <8736lzpm0m.fsf@kamboji.qca.qualcomm.com>
        <20190430.120117.1616322040923778364.davem@davemloft.net>
        <87r29jo2jy.fsf@kamboji.qca.qualcomm.com>
        <20190505.005130.1921658214241614481.davem@davemloft.net>
Date:   Mon, 06 May 2019 11:29:34 +0300
In-Reply-To: <20190505.005130.1921658214241614481.davem@davemloft.net> (David
        Miller's message of "Sun, 05 May 2019 00:51:30 -0700 (PDT)")
Message-ID: <87v9yougsx.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: Kalle Valo <kvalo@codeaurora.org>
> Date: Tue, 30 Apr 2019 19:55:45 +0300
>
>> David Miller <davem@davemloft.net> writes:
>> 
>>> Thanks for the conflict resolution information, it is very helpful.
>>>
>>> However, can you put it into the merge commit text next time as well?
>>> I cut and pasted it in there when I pulled this stuff in.
>> 
>> A good idea, I'll do that. Just to be sure, do you mean that I should
>> add it only with conflicts between net and net-next (like in this case)?
>> Or should I add it everytime I see a conflict, for example between
>> wireless-drivers-next and net-next? I hope my question is not too
>> confusing...
>
> When there is a major conflict for me to resolve when I pull in your
> pull reqeust, please place the conflict resolution help text into the
> merge commit message.
>
> I hope this is now clear :-)

Got it now, thanks!

-- 
Kalle Valo
