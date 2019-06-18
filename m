Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1FC4A747
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 18:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729605AbfFRQo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 12:44:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49844 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729319AbfFRQo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 12:44:57 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2E8F21509BAD5;
        Tue, 18 Jun 2019 09:44:57 -0700 (PDT)
Date:   Tue, 18 Jun 2019 09:44:56 -0700 (PDT)
Message-Id: <20190618.094456.1711659871338190750.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net-next 00/11][pull request] Intel Wired LAN Driver Updates
 2019-06-17
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190617233336.18119-1-jeffrey.t.kirsher@intel.com>
References: <20190617233336.18119-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Jun 2019 09:44:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Mon, 17 Jun 2019 16:33:25 -0700

> This series contains updates to the iavf driver only.

Pulled, thanks Jeff.
