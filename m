Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 006921E9DF6
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 08:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbgFAGTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 02:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725778AbgFAGTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 02:19:22 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83667C061A0E
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 23:19:22 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id t18so10230479wru.6
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 23:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9Sd2L8UVRLWFseuiSFx6oaj12sSozLPSk/HpddGpgNk=;
        b=yoPUu7BOduLe6dQLaHnHtoFBIpx+C9wwAb7wu24iVxuCRVLGxxJKUGWt0mbXBylg6V
         XnvsW6df3B9Z3ZR7/2LO16JzAlFfWLkABYwX95d+zxbKs2EisFAHVGFb8z4UX4z2HXoQ
         OgFUekWHnauvIGLogCD50frC+Lpyhc4eBtLqzWndkVwOiJD9sRs6HWTI9hrbV9wd2MT7
         4pbhUsY4p90/OHOfDvi6RdEa1gNN9U9LbrfENx5u3/qiGSThSFJsWGhFwpHhZ1rlWrf/
         cRXEIQ1vKE18l5TZSd6FDimWOIc7OWa6QmgihwRc+plvrdAyhqSFWTDbZDJkU0iO06dw
         fQ1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9Sd2L8UVRLWFseuiSFx6oaj12sSozLPSk/HpddGpgNk=;
        b=LSv7WXNYEnnAdm2qnsFv0r98NZDa3SeeyufkB0XqFQJJ6/T9f4Qscw5udf3BwubAvZ
         xrSPWlBjiDHmcJ3r2QRMU6Qm9P/Ct8Kpvp069jmJ7xd88qtAQ1lRZgcvKzUhow2ap5RU
         P09dVKDy/tFPx9VMRINVCS2IrAHrMRl8+ARm8JRf5oV9cvURBbunqllLYbNBs8bfLcoT
         svRqJyPcITlsfn9ewJ5vfIwDDy8dWroY5sy2ddLZ2UGFxpfABIA/WdKgX+8SaEo3d81E
         fhmlSTLCq5WIW4JmxzqVJF5kX3QjMUMOrRpdX87Ght6nenYamY/TWL7ouQ4CE4QFqgqT
         xSkA==
X-Gm-Message-State: AOAM533og4htEhqgZy65rn9YQZrbS4oNk0f7sumeaWamTnHJb3wV56IT
        DnuBu4CDpAMwF7SgRqax5AfTO6Nl96E=
X-Google-Smtp-Source: ABdhPJwQQ6z5lYkvJtATWzA2n4EzlqkItJj7P2Hws0L/xiy0Dby/Cfe1KHkkkneAoJksuEE3aVHLdQ==
X-Received: by 2002:a5d:6986:: with SMTP id g6mr20977835wru.27.1590992361171;
        Sun, 31 May 2020 23:19:21 -0700 (PDT)
Received: from localhost (ip-78-102-58-167.net.upcbroadband.cz. [78.102.58.167])
        by smtp.gmail.com with ESMTPSA id i10sm3750506wrw.51.2020.05.31.23.19.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 23:19:20 -0700 (PDT)
Date:   Mon, 1 Jun 2020 08:19:19 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        michael.chan@broadcom.com, Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v3 net-next 1/6] devlink: Add 'enable_live_dev_reset'
 generic parameter.
Message-ID: <20200601061919.GB2282@nanopsycho>
References: <1590908625-10952-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <1590908625-10952-2-git-send-email-vasundhara-v.volam@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1590908625-10952-2-git-send-email-vasundhara-v.volam@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, May 31, 2020 at 09:03:40AM CEST, vasundhara-v.volam@broadcom.com wrote:
>This parameter controls the device's live reset capability. When
>enabled, a user can issue a separate command like 'ethtool --reset'
>or 'devlink dev reload' to reset the entire device in real time.
>
>This parameter can be useful, if the user wants to upgrade the
>firmware quickly with a momentary network outage.
>
>For example, if a user flashes a new firmware image and if this
>parameter is enabled, the user can immediately initiate reset of
>the device, to load the new firmware without reloading the driver
>manually or resetting the system.
>
>Cc: Jiri Pirko <jiri@mellanox.com>
>Cc: Jakub Kicinski <kuba@kernel.org>
>Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
>Signed-off-by: Michael Chan <michael.chan@broadcom.com>


NAck, please see the comment I wrote as a reply to the cover letter.
Thanks.
