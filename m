Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8420F1DA499
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 00:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726938AbgESWcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 18:32:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgESWcm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 18:32:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D91A5C061A0E;
        Tue, 19 May 2020 15:32:42 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3A188128EDAAA;
        Tue, 19 May 2020 15:32:41 -0700 (PDT)
Date:   Tue, 19 May 2020 15:32:39 -0700 (PDT)
Message-Id: <20200519.153239.1577517664546707472.davem@davemloft.net>
To:     vaibhavgupta40@gmail.com
Cc:     hkallweit1@gmail.com, vaibhav.varodek@gmail.com,
        netdev@vger.kernel.org, helgaas@kernel.org, bhelgaas@google.com,
        bjorn@helgaas.com, linux-kernel-mentees@lists.linuxfoundation.org,
        rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        skhan@linuxfoundation.org
Subject: Re: [PATCH net-next v3 0/2] realtek ethernet : use generic power
 management.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200518150214.100491-1-vaibhavgupta40@gmail.com>
References: <20200518150214.100491-1-vaibhavgupta40@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 19 May 2020 15:32:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vaibhav Gupta <vaibhavgupta40@gmail.com>
Date: Mon, 18 May 2020 20:32:12 +0530

> The purpose of this patch series is to remove legacy power management callbacks
> from realtek ethernet drivers.
> 
> The callbacks performing suspend() and resume() operations are still calling
> pci_save_state(), pci_set_power_state(), etc. and handling the powermanagement
> themselves, which is not recommended.
> 
> The conversion requires the removal of the those function calls and change the
> callback definition accordingly.
> 
> All Changes are compile-tested only.

Series applied, thanks.
