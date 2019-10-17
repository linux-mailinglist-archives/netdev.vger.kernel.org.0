Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC4C8DB2F6
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 19:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440561AbfJQRF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 13:05:57 -0400
Received: from mout.gmx.net ([212.227.15.15]:36949 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732079AbfJQRF5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Oct 2019 13:05:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1571331934;
        bh=D2nr+/uIr9daJJyGdGVYoHj2YBBt7jtI817EfrG1QpU=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=JHrR07j7MDHWNk3fD/4CMJ7g4axYEyFiJucH1dvF27ls3JFWYxwPn+n0ausS20Nvr
         MYRs6WlmD1/U2g7GCvMmFaS3GXDrwAH7PlxHhYfROInsqhFkWoVpQA4F/Ihws6FM0S
         9eq+7Wd/pwtzM5z0XMVMwb3vVFWt4UxGDmV3GE5g=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.1.162] ([37.4.249.112]) by mail.gmx.com (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MEm2D-1iFNWX3BwR-00GJPX; Thu, 17
 Oct 2019 19:05:34 +0200
Subject: Re: lan78xx and phy_state_machine
To:     Daniel Wagner <dwagner@suse.de>, Andrew Lunn <andrew@lunn.ch>
Cc:     Woojung Huh <woojung.huh@microchip.com>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com,
        bcm-kernel-feedback-list@broadcom.com,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
References: <20191014140604.iddhmg5ckqhzlbkw@beryllium.lan>
 <20191015005327.GJ19861@lunn.ch>
 <20191015171653.ejgfegw3hkef3mbo@beryllium.lan>
 <20191016142501.2c76q7kkfmfcnqns@beryllium.lan>
 <20191016155107.GH17013@lunn.ch>
 <20191017065230.krcrrlmedzi6tj3r@beryllium.lan>
From:   Stefan Wahren <wahrenst@gmx.net>
Message-ID: <6f445327-a2bc-fa75-a70a-c117f2205ecd@gmx.net>
Date:   Thu, 17 Oct 2019 19:05:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191017065230.krcrrlmedzi6tj3r@beryllium.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Provags-ID: V03:K1:9IAKT4IiX7+DDHiuY01ulMUJkFGfba8XIzS9j0mYloTIT6b7IMF
 +LLrgwE1nLdb3KfDiw2CWIEFQ9K4wFRjVmKgbByDB3U2fvKiKILh7dw2VmQxWIGXNvtaogc
 5ZVrmQEohfD38gwvr+SthzKG1UnK8rjGpMe+r0ogdRGKLvzB3GdBvfK69yPx4CS4Pc6S2GS
 Y00K26hwaQvO+a1IyMJYA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Xzp56fR6mWY=:NhqZMMzbS9aS1wktFFEX+8
 DehkTQE76WkqzqceJsZ9mv81OTmdtvqUxFRkRkzW7dR3HSzToWuvj/S9S3EQhjw4gHXVBheAv
 tAtR00PoRlLrM+6HeUTH+ayxz7FpAiMpKjx6Pb0NPYvOBdy8OeiYv6T5Qz5/bdYF8dpxSfLi7
 5L/mOysYkUIRhs7YVxgAc8tmxevN9TuAJhD8ZfMPiaaA3ALV7awZAvwnKZeo6hbz3NRVwsrVF
 GqUDH5v5ucBredJL+Im9L/AC5XX75O+e+MRLsDDPnbcY73z4HKFbCiZhUPK2xD/i7ca98gcrU
 nt06MwbYhOfk3s+21pFJ+hN80STXVy4ACE76WGvtjnmzTK5Sr0fhAKYAcjuEtrkWYZV/pKFzt
 h6A555GerISg7lkC7094WJyaa9IJXHKnLbv8a6b3vWrty5dS7N52LZ7QgaYzZHDh/yBmt5jVq
 bqpXun756dntcDuOEwnhZ6BuRYhCirOK60xujmJD6Q7yOaZRSrSwD2afiFHwnw3h7Way6gjsO
 zmDxuT98KAjF3EH9V7NkTP4p9Ml/Mz3/cHLp3qWpXD49JRowJWVZLGOuK3+bzkv+CSvAt3m7q
 f/2FbG7GqavZxKHt7Tcd1SfZxLxnBffzzzhUC9MeE0z5gW6Aa6Bh2T9SONKXUpiB3Ne7qZTmV
 icTWZXCstWV37jpw/4SmtEweFW04H9a4NRZsrWVFHDFAdCl0wZiBxmcy1zp8D1eTG5k64Q2l7
 jgd5ioOXXjBeVjtDqHc9SnPj2ZZyTn5fJvbK0ZrN3RujuBHyTn2xo5jG7Rxnu1/tbkzGUnkC8
 eDr5cXWk+kvBErn99eBARy+g0t6PrS1jzgnFxgZ2nU03bcxjNoFqxeAeyRiI5T/jqGp/lgeQW
 1R8Hy6f7kHTxIvsFrMcvQRJyMK2+iG+mXrhEQcFKXqtIZW8TnlYdfqbhB4/qjbomhmZ7mkkfp
 AFhAKRfYP4FN1FyV/flk/6g+Ftal3Fvu6MRvZ6IsKbGb68xA9isVOFWwdblJ0eYcyTzcwb8lV
 8ZziQN6d68WbTFNEbLlkHBSgpMd6zGxeMT6d1+JRpDFcIy2MzuPkcn7uyy6CGWRsOl7oYWoIz
 6eFk6BZpOiSIdiktcwdvhcYkLt5IO+pQKG1FHZABcqUKLyorFL/sxb1kDoSUjMETkSudDJPac
 Q+1dUMMAiEgPOPbvzFJY9oRVp5zuf3BZFjvp7M9j57sDxBjQ4bQ47kGYIlIWbah9DwXgNNHKu
 zCbpbrjW36M9wV4yMmQeEGmvhUzHqbfxB4ulFiw81ICcWWx6wt/ePitqYEf4=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

Am 17.10.19 um 08:52 schrieb Daniel Wagner:
> On Wed, Oct 16, 2019 at 05:51:07PM +0200, Andrew Lunn wrote:
>> Hi Daniel
>>
>> Please could you give this a go. It is totally untested, not even
>> compile tested...
> Sure. The system boots but ther is one splat:
>
this is a known issues since 4.20 [1], [2]. So not related to the crash.

Unfortunately, you didn't wrote which kernel version works for you
(except of this splat). Only 5.3 or 5.4-rc3 too?

[1] - https://marc.info/?l=linux-netdev&m=154604180927252&w=2
[2] - https://patchwork.kernel.org/patch/10888797/

