Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4C8E6C8AAC
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 04:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231874AbjCYDg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 23:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjCYDg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 23:36:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F2FC1912A;
        Fri, 24 Mar 2023 20:36:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE358B82664;
        Sat, 25 Mar 2023 03:36:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 154BCC433D2;
        Sat, 25 Mar 2023 03:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679715414;
        bh=v3h3jktWpHMNnJXp0gnZOakSxruZO0wKM8dUpn0YVfk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dtNhVLggFNDE0sovKqnnGWRhyIkWd2LY+BYbj08TK7C6F4GbI63AFKMkp5rLhpf0a
         rSUluYjpm8e5OHfY+xl6dq2gdoAXKTT9oS62DjdYZqGpb3rYRzElPBs3KycTcuczJg
         C8nV9+xysmcyaHOM4ShLcoCOIRi/L3leOgs1eMBkT8jFmxvLDGYAhyC2kNpUziWEu2
         xe+wR2jMOOqd5Lw/H/JLDuIymUJjMgZZRLkncYGtRZx2YZsIVOb4KxNeN7UhjEHGsK
         S7ttU1ADTzmn65bEOzP4WKbwSw4mVtSJTa6ZgpqvDebamlHczvWBPrjzJJha/X5hkB
         +NazSsmF1RFMA==
Date:   Fri, 24 Mar 2023 20:36:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Donald Hunter <donald.hunter@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        donald.hunter@redhat.com
Subject: Re: [PATCH net-next v4 1/7] tools: ynl: Add struct parsing to
 nlspec
Message-ID: <20230324203652.1b03cb66@kernel.org>
In-Reply-To: <20230324191900.21828-2-donald.hunter@gmail.com>
References: <20230324191900.21828-1-donald.hunter@gmail.com>
        <20230324191900.21828-2-donald.hunter@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Mar 2023 19:18:54 +0000 Donald Hunter wrote:
> Add python classes for struct definitions to nlspec
> 
> Signed-off-by: Donald Hunter <donald.hunter@gmail.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
