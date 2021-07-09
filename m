Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E15C3C2874
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 19:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbhGIRfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 13:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbhGIRfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 13:35:02 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28BC0C0613E5
        for <netdev@vger.kernel.org>; Fri,  9 Jul 2021 10:32:18 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id hc16so17545421ejc.12
        for <netdev@vger.kernel.org>; Fri, 09 Jul 2021 10:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=llrIKsOm/6jqQkwaVXtBD5s+GtojxsAjJ2JSPa36cxQ=;
        b=h8YJpAbUiTa3DcAkFogZ4tSlnTfz/GW9M1A5BDZVHZU0gPizjnsjvJHjPnPPvc8HAO
         we3hT+VNhj58Ttg72yQTYzMDPOcry2TVavDQZ1jBSQF/LwYrlm74m5cv41okTebYw4bM
         5E1rzCPAC1oHm3SdF9XbNXVd56rgD21kVei00=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=llrIKsOm/6jqQkwaVXtBD5s+GtojxsAjJ2JSPa36cxQ=;
        b=HXTOJngnF95AFRBBxYwZFCSFNnVkLjH/o21c02XRCW6u6urzhUJmDlvJXbUKY0S4Vd
         kXn2CuT+sAOMG/Z2DtMF7isVVkmqvQJQhnZwWcoklrEROVUJORrCiahPW5sgolXzJGOw
         Lo1cTRkqn1WAB+guMGiGZ/U9dWGveS8JvyMfw5NR0CFj3tm2xfXw/1Mx04tkYxVSJQte
         iPtO/kZ8JfhnLpSo2VQ/4CdTF3KUE1Dib2+UTiOPcu7HI1ms3HJSPIT982ioyRu6mPVh
         GP0lwP6E0KAqNQBhBCJgjH8DLogpD3wwqLwbZPBHJGZXwpe3qGdK8d7x7rxKTzNDCMWf
         94aQ==
X-Gm-Message-State: AOAM530e2tS+vmaw7Q3cf/CMPHeb6FDkmNT6vlMY1q+XvuOXbyfISpsA
        84EgCjIP2N1UyEujs4rZa9AP0TiXT1lTauwIZuy+sg==
X-Google-Smtp-Source: ABdhPJxzLNbuQQViV0380pH4y0DjDVhLWcRMKCy37+1dHHtYzXsWWMnsyYvD4mSIwgawUz/IIXfpCWJ+Sw53InWTUqs=
X-Received: by 2002:a17:907:72c9:: with SMTP id du9mr23993406ejc.497.1625851936647;
 Fri, 09 Jul 2021 10:32:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210702223155.1981510-1-jforbes@fedoraproject.org>
In-Reply-To: <20210702223155.1981510-1-jforbes@fedoraproject.org>
From:   Justin Forbes <jmforbes@linuxtx.org>
Date:   Fri, 9 Jul 2021 12:32:06 -0500
Message-ID: <CAFxkdApGUeGdg4=rH=iC2SK58FO6yzbFiq3uSFMFTyZsDQ5j5w@mail.gmail.com>
Subject: Re: [PATCH] iwlwifi Add support for ax201 in Samsung Galaxy Book
 Flex2 Alpha
To:     Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matti Gottlieb <matti.gottlieb@intel.com>,
        ybaruch <yaara.baruch@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Ihab Zhaika <ihab.zhaika@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        linux-wireless@vger.kernel.org,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 2, 2021 at 5:32 PM Justin M. Forbes
<jforbes@fedoraproject.org> wrote:
>
> The Samsung Galaxy Book Flex2 Alpha uses an ax201 with the ID a0f0/6074.
> This works fine with the existing driver once it knows to claim it.
> Simple patch to add the device.
>
> Signed-off-by: Justin M. Forbes <jforbes@fedoraproject.org>
> ---

Just an update from the user with this hardware that I built a test kernel for:
"Still going strong w/ AX201, speed OK, on par w/ speeds on windows,
no crashes, no weird messages about the driver."

Justin
