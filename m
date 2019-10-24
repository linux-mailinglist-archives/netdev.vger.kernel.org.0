Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43FCBE38DB
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 18:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409927AbfJXQvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 12:51:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49058 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405516AbfJXQvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 12:51:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 95B6C14788BA3;
        Thu, 24 Oct 2019 09:51:50 -0700 (PDT)
Date:   Thu, 24 Oct 2019 09:51:50 -0700 (PDT)
Message-Id: <20191024.095150.1788364595890052897.davem@davemloft.net>
To:     richardcochran@gmail.com
Cc:     Igor.Russkikh@aquantia.com, netdev@vger.kernel.org,
        epomozov@marvell.com, Dmitry.Bezrukov@aquantia.com, andrew@lunn.ch,
        sedelhaus@marvell.com
Subject: Re: [PATCH v3 net-next 00/12] net: aquantia: PTP support for AQC
 devices
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191024141217.GC1435@localhost>
References: <cover.1571737612.git.igor.russkikh@aquantia.com>
        <20191024141217.GC1435@localhost>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 24 Oct 2019 09:51:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Richard Cochran <richardcochran@gmail.com>
Date: Thu, 24 Oct 2019 07:12:17 -0700

> On Tue, Oct 22, 2019 at 09:53:20AM +0000, Igor Russkikh wrote:
>> This patchset introduces PTP feature support in Aquantia AQC atlantic driver.
>> 
>> This implementation is a joined effort of aquantia developers:
>> Egor is the main designer and driver/firmware architect on PTP,
>> Sergey and Dmitry are included as co-developers.
>> Dmitry also helped me in the overall patchset preparations.
>> 
>> Feature was verified on AQC hardware with testptp tool, linuxptp,
>> gptp and with Motu hardware unit.
>> 
>> version3 updates:
>> - Review comments applied: error handling, various fixes
> 
> For the series:
> 
> Acked-by: Richard Cochran <richardcochran@gmail.com>

Series applied.

Igor, please address the issues reported by the kbuild robot.

Thank you.
