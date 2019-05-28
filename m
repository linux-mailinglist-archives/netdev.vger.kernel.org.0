Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 488242CE15
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 19:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727741AbfE1R7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 13:59:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49172 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726827AbfE1R7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 13:59:07 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 001C112D6BBFD;
        Tue, 28 May 2019 10:59:05 -0700 (PDT)
Date:   Tue, 28 May 2019 10:59:05 -0700 (PDT)
Message-Id: <20190528.105905.1984032479752781822.davem@davemloft.net>
To:     horatiu.vultur@microchip.com
Cc:     alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        robh+dt@kernel.org, mark.rutland@arm.com, ralf@linux-mips.org,
        paul.burton@mips.com, jhogan@kernel.org,
        linux-mips@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: mscc: ocelot: Add support for tcam
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1558944996-23069-2-git-send-email-horatiu.vultur@microchip.com>
References: <1558944996-23069-1-git-send-email-horatiu.vultur@microchip.com>
        <1558944996-23069-2-git-send-email-horatiu.vultur@microchip.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 May 2019 10:59:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Horatiu Vultur <horatiu.vultur@microchip.com>
Date: Mon, 27 May 2019 10:16:35 +0200

> +/* Calculate offsets for entry */
> +static void is2_data_get(struct vcap_data *data, int ix)
> +{
> +	const struct vcap_props *vcap = &vcap_is2;
> +	u32 i, col, offset, count, cnt, base, width = vcap->tg_width;

Reverse christmas tree please.

> +static void is2_entry_set(struct ocelot *ocelot, int ix,
> +			  struct ocelot_ace_rule *ace)
> +{
> +	u32 val, msk, type, type_mask = 0xf, i, count;
> +	struct ocelot_vcap_u64 payload = { 0 };
> +	struct ocelot_ace_vlan *tag = &ace->vlan;
> +	struct vcap_data data = { 0 };
> +	int row = (ix / 2);

Likewise.

> +static void is2_entry_get(struct ocelot_ace_rule *rule, int ix)
> +{
> +	struct vcap_data data;
> +	struct ocelot *op = rule->port->ocelot;
> +	int row = (ix / 2);
> +	u32 cnt;

Likewise.

> +static void ocelot_ace_rule_add(struct ocelot_acl_block *block,
> +				struct ocelot_ace_rule *rule)
> +{
> +	struct list_head *pos, *n;
> +	struct ocelot_ace_rule *tmp;

Likewise.

And so on and so forth for your entire submission.

Thank you.
