Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 583859F8EF
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 05:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbfH1DzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 23:55:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54450 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbfH1DzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 23:55:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5923A153BA91E;
        Tue, 27 Aug 2019 20:55:01 -0700 (PDT)
Date:   Tue, 27 Aug 2019 20:55:00 -0700 (PDT)
Message-Id: <20190827.205500.2094153294135948781.davem@davemloft.net>
To:     nhorman@tuxdriver.com
Cc:     lucien.xin@gmail.com, netdev@vger.kernel.org,
        linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com
Subject: Re: [PATCH net-next 0/3] sctp: add SCTP_ECN_SUPPORTED sockopt
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190826110221.GA7831@hmswarspite.think-freely.org>
References: <cover.1566807985.git.lucien.xin@gmail.com>
        <20190826110221.GA7831@hmswarspite.think-freely.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 27 Aug 2019 20:55:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 26 Aug 2019 07:02:21 -0400

> On Mon, Aug 26, 2019 at 04:30:01PM +0800, Xin Long wrote:
>> This patchset is to make ecn flag per netns and endpoint and then
>> add SCTP_ECN_SUPPORTED sockopt, as does for other feature flags.
>> 
>> Xin Long (3):
>>   sctp: make ecn flag per netns and endpoint
>>   sctp: allow users to set netns ecn flag with sysctl
>>   sctp: allow users to set ep ecn flag by sockopt
 ...
> Series
> Acked-by: Neil Horman <nhorman@tuxdriver.com>

Series applied to net-next, thanks.
