Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC44336DA
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 19:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728097AbfFCRfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 13:35:33 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60870 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726604AbfFCRfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 13:35:33 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 344F714BEB0E9;
        Mon,  3 Jun 2019 10:35:32 -0700 (PDT)
Date:   Mon, 03 Jun 2019 10:35:31 -0700 (PDT)
Message-Id: <20190603.103531.2133053175080286848.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        jiri@mellanox.com, shalomt@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net-next 0/9] mlxsw: Add support for physical hardware
 clock
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190603121244.3398-1-idosch@idosch.org>
References: <20190603121244.3398-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Jun 2019 10:35:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Mon,  3 Jun 2019 15:12:35 +0300

> This is the first of about four patchsets that add PTP support in mlxsw
> for the Spectrum-1 ASIC.

Richard, could you give this a quick review?

Thank you.
