Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E862C10A5E3
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 22:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbfKZVTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 16:19:46 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42446 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfKZVTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 16:19:46 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D9EF914CED4B3;
        Tue, 26 Nov 2019 13:19:45 -0800 (PST)
Date:   Tue, 26 Nov 2019 13:19:45 -0800 (PST)
Message-Id: <20191126.131945.1705488455872187863.davem@davemloft.net>
To:     tlfalcon@linux.ibm.com
Cc:     jakub.kicinski@netronome.com, netdev@vger.kernel.org,
        linuxppc-dev@ozlabs.org, dnbanerg@us.ibm.com,
        brking@linux.vnet.ibm.com, julietk@linux.vnet.ibm.com
Subject: Re: [PATCH net v2 0/4] ibmvnic: Harden device commands and queries
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1574723576-27553-1-git-send-email-tlfalcon@linux.ibm.com>
References: <20191125112359.7a468352@cakuba.hsd1.ca.comcast.net>
        <1574723576-27553-1-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 26 Nov 2019 13:19:46 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Falcon <tlfalcon@linux.ibm.com>
Date: Mon, 25 Nov 2019 17:12:52 -0600

> This patch series fixes some shortcomings with the current
> VNIC device command implementation. The first patch fixes
> the initialization of driver completion structures used
> for device commands. Additionally, all waits for device
> commands are bounded with a timeout in the event that the
> device does not respond or becomes inoperable. Finally,
> serialize queries to retain the integrity of device return
> codes.
> 
> Changes in v2:
> 
>  - included header comment for ibmvnic_wait_for_completion
>  - removed open-coded loop in patch 3/4, suggested by Jakub
>  - ibmvnic_wait_for_completion accepts timeout value in milliseconds
>    instead of jiffies
>  - timeout calculations cleaned up and completed before wait loop
>  - included missing mutex_destroy calls, suggested by Jakub
>  - included comment before mutex declaration

Series applied, thanks.
