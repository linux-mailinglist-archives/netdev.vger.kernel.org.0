Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36C9559070C
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 21:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235813AbiHKTlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 15:41:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234698AbiHKTlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 15:41:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7577022BEE;
        Thu, 11 Aug 2022 12:41:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27651B82206;
        Thu, 11 Aug 2022 19:41:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67AD8C433D6;
        Thu, 11 Aug 2022 19:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660246867;
        bh=gAAxfoPHl8OGvR/WyakgVLVnHoxFCjBGaBzbS0GzPPQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Pa4ZLUijYuGHlF8LVBOOVXP5HWaVei8WAojWrNOIIhDYGqlNr2bolJ3JINqRgRCjQ
         kWGcwnCQEiKFRQaKosgDUZ1r+yHVQXarC45LmwVxVe4Lx67yFPOfp7voQYLfNo93nq
         LM+qQsipnVb+UPwpLyzCjT6beAvmkfZi06LSgTClOgooWBefaxqlWimnzlLaTzZqJV
         y+ifV+H2roPEkQMK8ded8e62t3Tmvu8USq1S2OdPy3kYqIZLVyZvd4zvybOaz/V8xE
         oL9p4nLQYprXoRgnTMANcqIrQw0qAlWDCrOxvkMj16OTodvKyi38/iIniEU+Ocgo8H
         jb1nKNF7KpBdA==
Date:   Thu, 11 Aug 2022 12:41:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PULL] Networking for 6.0-rc1
Message-ID: <20220811124106.703917f8@kernel.org>
In-Reply-To: <20220811120902.7e82826a@kernel.org>
References: <20220811185102.3253045-1-kuba@kernel.org>
        <20220811120902.7e82826a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Aug 2022 12:09:02 -0700 Jakub Kicinski wrote:
> Let's put this one on hold, sorry. We got a report 2 minutes after
> sending that one of the BT patches broke mips and csky builds :S
> I'll try to get hold of Luiz and fix that up quickly.

Can I take that back? I can't repro with the cross compiler 
from kernel.org. I'll follow up with the reported separately.
