Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8FC43D1B0
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 21:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240825AbhJ0TcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 15:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240761AbhJ0TcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 15:32:01 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 031E6C061570;
        Wed, 27 Oct 2021 12:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=vnd1blMlmg50+eejJOJq5W4w5Dsqbt1wlIGlXdBKkB4=; b=NweHzQEf3LwTA18tRMJ5VuR2aq
        D+Fnw/NGchjU2zJZoiTXWyIF7a3i4NYN9yq8r+aVSZSq/G7HwQ7Txsu/eDKhyP9hBHzIBuyCuShra
        /4JCdat3Ny7j0I01RGdgMMUcWYI8hAax988ujuPg4Vg98G1Cii1LUIGLrOZrpcIsdCTYQqmh2IrH8
        IwCDCSDINyd17h5V6CCVmMfL0X4wgzJhnlLBj2YDyPIxbaNTs1X/XdUaQ7/VVtBbs2fOhlXA6n1co
        pRaXtXkrOv4QEJs/tLU/3wkGi7OpVc2AdM3vNfQNj60abece6S9k2NfzNq4X+9bLoz2oRje2d3aLd
        pjXdXpaQ==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mfocB-005wST-Gu; Wed, 27 Oct 2021 19:29:35 +0000
Subject: Re: Unsubscription Incident
To:     Slade Watkins <slade@sladewatkins.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Lijun Pan <lijunp213@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
References: <CAOhMmr7bWv_UgdkFZz89O4=WRfUFhXHH5hHEOBBfBaAR8f4Ygw@mail.gmail.com>
 <YXcGPLau1zvfTIot@unknown>
 <CA+pv=HPK+7JVM2d=C2B6iBY+joW7T9RWrPGDd-VXm09yaWsQYg@mail.gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <1d5ccba0-d607-aabc-6bd1-0e7c754c8379@infradead.org>
Date:   Wed, 27 Oct 2021 12:29:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CA+pv=HPK+7JVM2d=C2B6iBY+joW7T9RWrPGDd-VXm09yaWsQYg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/26/21 5:02 PM, Slade Watkins wrote:
> Hi,
> On Mon, Oct 25, 2021 at 4:10 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>>
>> On Fri, Oct 22, 2021 at 10:53:28AM -0500, Lijun Pan wrote:
>>> Hi,
>>>
>>>  From Oct 11, I did not receive any emails from both linux-kernel and
>>> netdev mailing list. Did anyone encounter the same issue? I subscribed
>>> again and I can receive incoming emails now. However, I figured out
>>> that anyone can unsubscribe your email without authentication. Maybe
>>> it is just a one-time issue that someone accidentally unsubscribed my
>>> email. But I would recommend that our admin can add one more
>>> authentication step before unsubscription to make the process more
>>> secure.
>>>
>>
>> Same here.
>>
>> Fortunately I just switched to lei:
>> https://josefbacik.github.io/kernel/2021/10/18/lei-and-b4.html
>> so I can unsubscribe all kernel mailing lists now.
> 
> Not a bad workaround! I may consider trying this out. Thanks for
> sending this along.
> 
> I'd still love to figure out why the whole "randomly unsubscribing
> people who want to be subscribed" thing is happening in the first
> place, though.

Then you should try <postmaster@vger.kernel.org> for assistance.

-- 
~Randy
