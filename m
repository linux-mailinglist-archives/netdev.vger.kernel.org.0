Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD642529C09
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 10:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242962AbiEQIOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 04:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242995AbiEQIN3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 04:13:29 -0400
Received: from smtp-bc0b.mail.infomaniak.ch (smtp-bc0b.mail.infomaniak.ch [IPv6:2001:1600:3:17::bc0b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A99A54991E
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 01:12:36 -0700 (PDT)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4L2TPZ5H7rzMrBqC;
        Tue, 17 May 2022 10:12:34 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4L2TPZ1y6qzlhMC5;
        Tue, 17 May 2022 10:12:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1652775154;
        bh=Wlo13ZQ1fjXEj/AZR+D+T5bedv0V+KydvqaxiHUOJb4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=i8mUt8stPxvNARDvMT22qV9SlqPmrMhW1geD9DVQPe805afS53dp4bBcbG6oy23Y6
         pwK2edYJdAwdX+H8yCYlTHz+XMFzKI9W0Bv077HHH7+7jWMo8tzPpBWymBO06/rtw9
         Ngrqtg1xJLWkJO915sPcTDAoEsLhJoO82TOPXQEk=
Message-ID: <a6300c07-87f5-21a4-8998-facbecd63787@digikod.net>
Date:   Tue, 17 May 2022 10:12:33 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v5 01/15] landlock: access mask renaming
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        anton.sirazetdinov@huawei.com
References: <20220516152038.39594-1-konstantin.meskhidze@huawei.com>
 <20220516152038.39594-2-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <20220516152038.39594-2-konstantin.meskhidze@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 16/05/2022 17:20, Konstantin Meskhidze wrote:
> Currently Landlock supports filesystem
> restrictions. To support network type rules,
> this modification extends and renames
> ruleset's access masks.
> This patch adds filesystem helper functions
> to set and get filesystem mask. Also the modification
> adds a helper structure landlock_access_mask to
> support managing multiple access mask.
> 
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---

[...]

> diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
> index d43231b783e4..f27a79624962 100644
> --- a/security/landlock/ruleset.h
> +++ b/security/landlock/ruleset.h
> @@ -20,6 +20,7 @@
>   #include "object.h"
> 
>   typedef u16 access_mask_t;
> +
>   /* Makes sure all filesystem access rights can be stored. */

Please don't add whitespaces.
