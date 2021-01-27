Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3F91305E82
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 15:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233678AbhA0OmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 09:42:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233800AbhA0OlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 09:41:14 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E8CC061574;
        Wed, 27 Jan 2021 06:40:34 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id dj23so2689204edb.13;
        Wed, 27 Jan 2021 06:40:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9zErTV/C8Lhzmf/nQvtFRN+tkN24OhU/eILu8R6oN1I=;
        b=OJnSimKLoxPeLAGxGe2ffrLml242wWTZuZfKz/6fFpT2s/8cCzqe/kPcv/OZf8g8z7
         74pJ3BkcF6+rk2plxd5EUTXxUokhzWG8bfQGSV3cU5cYSyDW/QbfDo7wCzGQwea1NqJp
         ZRUoQoV9a4XAof3fJOqFeKbj9wE01MnEMPrsdRShKCecWlaegyw4Ipq/Xwx+2FqcM3XL
         pTRg950b94OqbLz6ZER/G1Qut9MmrmClraNvlRfOLfiU8Uqj1l6mLZjn52eOVOCzXMNs
         6xuBCNtQus608QT7PB31EGe1LZmBE41sUqCJsG3jDz2PGehxrS4dUb8xZvoAcGjWF89e
         yToQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9zErTV/C8Lhzmf/nQvtFRN+tkN24OhU/eILu8R6oN1I=;
        b=OMt/qlMPlMtZ7K67jrgVJs/P8iMRXnIKHqm1Vx0AE6RKj75+ry+4RZFIROt0dZgLil
         hfEw8JrQ7nm8sJXoffXhaz0OAt4q3e292feqDw+CeSbb8TzDWFVJp59YdiZI0LsUtffJ
         wqcqVH4AwO4+HnrsuIJn4DkUJHIsiYfOsM/IhNVIJzlhWHUD3xFyMq4xr4/5sA3cb7+F
         lpaGnusG4K9DqJZ88um9FOMdFX/SHRIl6c2FgtKSkiA8AUQ8YFIs2CH2vEBcR0csDfBF
         CzX65EbKYBfL9+seIzLkG8j86ceQg1LpZn+74FHBJJevJ6rHpvsAHf1InRYA76hCdZ2l
         R9zg==
X-Gm-Message-State: AOAM533IlOuXVKtMiKid6VTMO/2jv7ObDxWk9vEhmuil0fSXQ4HcNxfS
        87GavNDquVVaCG1RQsNLyguj/O3fQPoVawdqOCI=
X-Google-Smtp-Source: ABdhPJz473Msx0yzTfHDOAZxne7B5h2ap2YUpPKTwQMHjVWv7QyV74BlWnL2oK+l427DPRDzsdaSPX6FuJGQDBbRLxU=
X-Received: by 2002:a05:6402:149a:: with SMTP id e26mr9639467edv.254.1611758432946;
 Wed, 27 Jan 2021 06:40:32 -0800 (PST)
MIME-Version: 1.0
References: <20210126185703.29087-1-elder@linaro.org>
In-Reply-To: <20210126185703.29087-1-elder@linaro.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 27 Jan 2021 09:39:56 -0500
Message-ID: <CAF=yD-JRY5P-u2ETN4Dsc4U3jQ3kRAnPt6EDPtZ3MdVcrnyLmQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 0/6] net: ipa: hardware pipeline cleanup fixes
To:     Alex Elder <elder@linaro.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, elder@kernel.org,
        evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 5:04 AM Alex Elder <elder@linaro.org> wrote:
>
> Version 2 of this series fixes a "restricted __le16 degrades to
> integer" warning from sparse in the third patch.  The normal host
> architecture is little-endian, so the problem did not produce
> incorrect behavior, but the code was wrong not to perform the
> endianness conversion.  The updated patch uses le16_get_bits() to
> properly extract the value of the field we're interested in.
>
> Everything else remains the same.  Below is the original description.
>
>                                         -Alex
>
> There is a procedure currently referred to as a "tag process" that
> is performed to clear the IPA hardware pipeline--either at the time
> of a modem crash, or when suspending modem GSI channels.
>
> One thing done in this procedure is issuing a command that sends a
> data packet originating from the AP->command TX endpoint, destined
> for the AP<-LAN RX (default) endpoint.  And although we currently
> wait for the send to complete, we do *not* wait for the packet to be
> received.  But the pipeline can't be assumed clear until we have
> actually received this packet.
>
> This series addresses this by detecting when the pipeline-clearing
> packet has been received, and using a completion to allow a waiter
> to know when that has happened.  This uses the IPA status capability
> (which sends an extra status buffer for certain packets).  It also
> uses the ability to supply a "tag" with a packet, which will be
> delivered with the packet's status buffer.  We tag the data packet
> that's sent to clear the pipeline, and use the receipt of a status
> buffer associated with a tagged packet to determine when that packet
> has arrived.
>
> "Tag status" just desribes one aspect of this procedure, so some
> symbols are renamed to be more like "pipeline clear" so they better
> describe the larger purpose.  Finally, two functions used in this
> code don't use their arguments, so those arguments are removed.
>
>                                         -Alex
>
> Alex Elder (6):
>   net: ipa: rename "tag status" symbols
>   net: ipa: minor update to handling of packet with status
>   net: ipa: drop packet if status has valid tag
>   net: ipa: signal when tag transfer completes
>   net: ipa: don't pass tag value to ipa_cmd_ip_tag_status_add()
>   net: ipa: don't pass size to ipa_cmd_transfer_add()
>
>  drivers/net/ipa/ipa.h          |  2 +
>  drivers/net/ipa/ipa_cmd.c      | 45 +++++++++++++------
>  drivers/net/ipa/ipa_cmd.h      | 24 ++++++-----
>  drivers/net/ipa/ipa_endpoint.c | 79 ++++++++++++++++++++++++++--------
>  drivers/net/ipa/ipa_main.c     |  1 +
>  5 files changed, 109 insertions(+), 42 deletions(-)

For netdrv

Acked-by: Willem de Bruijn <willemb@google.com>
