Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55EF4248F87
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 22:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbgHRUQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 16:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgHRUQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 16:16:58 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96192C061389
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 13:16:58 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 17193127B3373;
        Tue, 18 Aug 2020 13:00:12 -0700 (PDT)
Date:   Tue, 18 Aug 2020 13:16:57 -0700 (PDT)
Message-Id: <20200818.131657.963549389331033291.davem@davemloft.net>
To:     awogbemila@google.com
Cc:     netdev@vger.kernel.org, sagis@google.com, yangchun@google.com
Subject: Re: [PATCH net-next 06/18] gve: Batch AQ commands for creating and
 destroying queues.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200818194417.2003932-7-awogbemila@google.com>
References: <20200818194417.2003932-1-awogbemila@google.com>
        <20200818194417.2003932-7-awogbemila@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Aug 2020 13:00:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Awogbemila <awogbemila@google.com>
Date: Tue, 18 Aug 2020 12:44:05 -0700

> -int gve_adminq_execute_cmd(struct gve_priv *priv,
> -			   union gve_adminq_command *cmd_orig)
> +static int gve_adminq_issue_cmd(struct gve_priv *priv,
> +				union gve_adminq_command *cmd_orig)
>  {
>  	union gve_adminq_command *cmd;
> +	u32 tail;
>  	u32 opcode;

Please use reverse christmas tree ordering for local variables.

Thanks.
