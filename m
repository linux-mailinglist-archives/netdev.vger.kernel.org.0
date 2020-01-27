Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8354014A15F
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 11:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgA0KAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 05:00:48 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36846 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbgA0KAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 05:00:48 -0500
Received: from localhost (unknown [213.175.37.12])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 49A4415059D05;
        Mon, 27 Jan 2020 02:00:46 -0800 (PST)
Date:   Mon, 27 Jan 2020 11:00:44 +0100 (CET)
Message-Id: <20200127.110044.1854774444298391044.davem@davemloft.net>
To:     steffen.klassert@secunet.com
Cc:     willemb@google.com, pabeni@redhat.com, subashab@codeaurora.org,
        marcelo.leitner@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/4] Support fraglist GRO/GSO
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200125102645.4782-1-steffen.klassert@secunet.com>
References: <20200125102645.4782-1-steffen.klassert@secunet.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Jan 2020 02:00:48 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Steffen Klassert <steffen.klassert@secunet.com>
Date: Sat, 25 Jan 2020 11:26:41 +0100

> This patchset adds support to do GRO/GSO by chaining packets
> of the same flow at the SKB frag_list pointer. This avoids
> the overhead to merge payloads into one big packet, and
> on the other end, if GSO is needed it avoids the overhead
> of splitting the big packet back to the native form.
 ...

Series applied, thank you Steffen.
