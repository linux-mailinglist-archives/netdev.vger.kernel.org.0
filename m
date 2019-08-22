Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 583329A372
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 01:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405502AbfHVXBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 19:01:45 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50196 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394190AbfHVXBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 19:01:45 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CBA1E15396DD0;
        Thu, 22 Aug 2019 16:01:44 -0700 (PDT)
Date:   Thu, 22 Aug 2019 16:01:44 -0700 (PDT)
Message-Id: <20190822.160144.1301428429264860069.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net-next 0/7][pull request] ipv6: Extension header
 infrastructure 
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190822225940.14235-1-jeffrey.t.kirsher@intel.com>
References: <20190822225940.14235-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 22 Aug 2019 16:01:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jeff, why are you submitting Tom's changes, can't he submit his
patches on his own?
