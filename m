Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E45AE31748C
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 00:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233582AbhBJXki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 18:40:38 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48938 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbhBJXkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 18:40:36 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 5C8814D2CA801;
        Wed, 10 Feb 2021 15:39:56 -0800 (PST)
Date:   Wed, 10 Feb 2021 15:39:55 -0800 (PST)
Message-Id: <20210210.153955.733041126428319029.davem@davemloft.net>
To:     sukadev@linux.ibm.com
Cc:     netdev@vger.kernel.org, drt@linux.ibm.com, ljp@linux.ibm.com,
        ricklind@linux.ibm.com
Subject: Re: [PATCH net v3] ibmvnic: fix a race between open and reset
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210210070947.GA852317@us.ibm.com>
References: <20210210070947.GA852317@us.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 10 Feb 2021 15:39:56 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For some reason git am thinks this is an empty patch when I pull it out of patchwork.

Please fiux that and resubmit, thank you.
