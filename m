Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 088A26189F3
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 21:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbiKCUx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 16:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbiKCUxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 16:53:24 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C648920F77;
        Thu,  3 Nov 2022 13:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
        Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=Jp6+mYPLdRQOOREydHlPzAY0N6dTwSJyALuM8gordWM=;
        t=1667508771; x=1668718371; b=QI+OK912Dbu/sWeAo5XZl3Fm8uM6ecgSO7RCDgEmg4xLKeC
        7s/6l2E0krpUmRuYOpDRn7TLPD+CzXjXkSetzom8hGOz+Wgx0CpafxJsgvwjfWlUadmW+cYU9MfoJ
        oR51l3YE9gr9l1lFW0nVdZReClEWO/paH7g3DEOrCX0n+aNiKYizBQ1uk6dU8BlVr3h2+TQaA9R5o
        sScRETi50p9LfK0jNJkGzX6yJNo7TgtjqnBDx9WX6Qp99TvCCOfmPQupVCeZh6fEYq8GzFj9XHN+f
        J0cMLVQDmSAJ4hQX1qVhvrxdZEyrFR2/2GmwlPHrUwV45QSQMQMWTN3CVvK6Ulog==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oqhCV-0084fg-1k;
        Thu, 03 Nov 2022 21:52:35 +0100
Message-ID: <f933bc0de15a4301e43207fe989e519fa25db31f.camel@sipsolutions.net>
Subject: Re: [PATCH] iwlwifi: fix style warnings in iwl-drv.c
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Linus Probert <linus.probert@gmail.com>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "open list:INTEL WIRELESS WIFI LINK (iwlwifi)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Thu, 03 Nov 2022 21:52:34 +0100
In-Reply-To: <Y2QTLgWVO2sZMnOb@firefly>
References: <Y2QTLgWVO2sZMnOb@firefly>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-11-03 at 20:14 +0100, Linus Probert wrote:
> Running checkpatch on iwl-drv.c produced a series of minor style
> warnings. Most of them have been removed. There are some remaining
> regarding multiple lines of quoted strings as well as some warnings
> where the suggested fix produces a new warning.

No thanks.

Some of these really shouldn't be fixed (like strings be broken?! I
thought we stopped this nonsense even in checkpatch), and anyway, this
will probably just cause conflicts for no good reason.

johannes

