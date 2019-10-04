Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9381CCC479
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 22:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730131AbfJDU4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 16:56:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58882 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbfJDU4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 16:56:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B304E14EC3082;
        Fri,  4 Oct 2019 13:56:08 -0700 (PDT)
Date:   Fri, 04 Oct 2019 13:56:05 -0700 (PDT)
Message-Id: <20191004.135605.2028145564221142133.davem@davemloft.net>
To:     rspmn@arcor.de
Cc:     bjorn@mork.no, netdev@vger.kernel.org
Subject: Re: [PATCH] qmi_wwan: add support for Cinterion CLS8 devices
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191003163439.GA1556@arcor.de>
References: <20191003163439.GA1556@arcor.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 04 Oct 2019 13:56:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Reinhard Speyerer <rspmn@arcor.de>
Date: Thu, 3 Oct 2019 18:34:39 +0200

> Add support for Cinterion CLS8 devices.
> Use QMI_QUIRK_SET_DTR as required for Qualcomm MDM9x07 chipsets. 
 ...
> Signed-off-by: Reinhard Speyerer <rspmn@arcor.de>

Applied.
