Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0F4C4F7611
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 08:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241120AbiDGGdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 02:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241166AbiDGGcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 02:32:39 -0400
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [81.169.146.221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB8CAB57
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 23:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1649313027;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=wfjRm8QcNJHqhp19poYjz4H/hzPs5bXXEfUr6VR3ml8=;
    b=joowql4aDk7xdRNoJoLPrmh/GimVSR+gxRkaA86pY7VjB52BL5rBfKlT5FBLAZJ9Xj
    Rtpgdr1xBEogfWZrhQGNhRevKqulbsnUoofYMtU5sSfu89VF5DZ2wOd+D3Q+SXIlFG85
    ojQ6/dcjKHw8gDQ9NekJPRC+JQVZ8u1EnyuoCEOKxCGL3iLAPRm3OktonIktwbyvl9gv
    GT850zRhZN06GrydHdu/hYdIA49YrwO7LVlCSNen4l4IbHkzUzCJNLqwTKFV8DwgOiKm
    uCgOq3I4hGaxVtrUwi6XzpURByih5UyFwuhH3BO/czfzkDWa0aT9cSjLd6Yy4X62leUp
    TjTA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdd0DIgVuBOfXW6v7w=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cfa:f900::b82]
    by smtp.strato.de (RZmta 47.42.2 AUTH)
    with ESMTPSA id 4544c9y376UQVFP
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Thu, 7 Apr 2022 08:30:26 +0200 (CEST)
Message-ID: <3ca031fa-c447-ec3d-6fd0-a7540a89d563@hartkopp.net>
Date:   Thu, 7 Apr 2022 08:30:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH RESEND net-next v4] net: remove noblock parameter from
 skb_recv_datagram()
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        kernel test robot <lkp@intel.com>
References: <20220404163022.88751-1-socketcan@hartkopp.net>
 <20220406220745.2fe27055@kernel.org>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20220406220745.2fe27055@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07.04.22 07:07, Jakub Kicinski wrote:

> We may have missed the pw bot's reply. Either that or vger ate it for
> me. Looks like this is commit f4b41f062c42 ("net: remove noblock
> parameter from skb_recv_datagram()") in net-next. Thanks!

Yes. I didn't get a notice too. vger seems to be really busy.

Thanks & best regards,
Oliver
