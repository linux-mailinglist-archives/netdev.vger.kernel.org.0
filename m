Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 308143721DB
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 22:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbhECUsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 16:48:17 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46164 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbhECUsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 16:48:16 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id E816A4D25963D;
        Mon,  3 May 2021 13:47:21 -0700 (PDT)
Date:   Mon, 03 May 2021 13:47:21 -0700 (PDT)
Message-Id: <20210503.134721.2149322673805635760.davem@davemloft.net>
To:     lijunp213@gmail.com
Cc:     msuchanek@suse.de, netdev@vger.kernel.org, mpe@ellerman.id.au,
        benh@kernel.crashing.org, paulus@samba.org, drt@linux.ibm.com,
        sukadev@linux.ibm.com, tlfalcon@linux.ibm.com, kuba@kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ibmvnic: remove default label from to_string switch
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAOhMmr701LecfuNM+EozqbiTxFvDiXjFdY2aYeKJYaXq9kqVDg@mail.gmail.com>
References: <20210503102323.17804-1-msuchanek@suse.de>
        <CAOhMmr701LecfuNM+EozqbiTxFvDiXjFdY2aYeKJYaXq9kqVDg@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Mon, 03 May 2021 13:47:22 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lijun Pan <lijunp213@gmail.com>
Date: Mon, 3 May 2021 13:21:00 -0500

> On Mon, May 3, 2021 at 5:54 AM Michal Suchanek <msuchanek@suse.de> wrote:
>>
>> This way the compiler warns when a new value is added to the enum but
>> not the string transation like:
> 
> s/transation/translation/
> 
> This trick works.
> Since the original code does not generate gcc warnings/errors, should
> this patch be sent to net-next as an improvement?

Yes.
