Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B088A28BEFE
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 19:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390741AbgJLR1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 13:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389613AbgJLR1W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 13:27:22 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70266C0613D0
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 10:27:22 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 09B195872C948; Mon, 12 Oct 2020 19:27:21 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 05D7360DB5336;
        Mon, 12 Oct 2020 19:27:21 +0200 (CEST)
Date:   Mon, 12 Oct 2020 19:27:21 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Stephen Hemminger <stephen@networkplumber.org>
cc:     netdev@vger.kernel.org
Subject: Re: [iproute PATCH v2] lib/color: introduce freely configurable
 color strings
In-Reply-To: <20201012100440.0de0be16@hermes.local>
Message-ID: <n53rpn94-172n-p571-188o-pq6915q8r323@vanv.qr>
References: <20201012164639.20976-1-jengelh@inai.de> <20201012100440.0de0be16@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Monday 2020-10-12 19:04, Stephen Hemminger wrote:
>
>> +static struct color_code {
>> +	const char match[8], *code;
>> +	int len;
>> +} color_codes[C_MAX] = {
>> +	{"iface="}, {"lladdr="}, {"v4addr="}, {"v6addr="}, {"operup="},
>> +	{"operdn="}, {"clear=", "0", 1},
>>  };
>
>Also if each match has = that maybe redundant.

The = is needed so that strncmp in set_color_palette will do an equality
match on the key name rather than a prefix match.
