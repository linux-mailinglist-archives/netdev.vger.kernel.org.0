Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 327C2193BD5
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 10:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727636AbgCZJ2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 05:28:54 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37338 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726292AbgCZJ2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 05:28:54 -0400
Received: by mail-wr1-f66.google.com with SMTP id w10so6841152wrm.4
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 02:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NZlKLgjrHkiImS8vVe6P9I5dWwV09bL6C8Ho9474AOI=;
        b=wOVA3Av17CXlfUCGQBENhdB0SpJa9UWK9gen8IPcreY2Da/OJnukCwRb2Dz2508QMa
         h6yG9V2ih2fkaHiie8CI3HCMNzSq7nyZeWfHGRdksKjZ3GqMZswBBfVcPhw1G0cLHXmk
         zCfUXLqlkd+DRCS32dQ1l2tGui/PVQ9azYEQ5Leqvw5B5smmcelqtR/r4Pp7urkcaXW3
         /AmIRZMEE/x0LVhS3Ok/akwXTc5gdT32zpdAg/2D8l0wTAFJwdA4gAuGGK0KIEjvSy/S
         Q0/BhwEIE1nS4ll7myNDRm03VP8Km4r3/4wlbLzP92PyXTbKOPT7P73t+EwkRHGcA/Zn
         VTFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NZlKLgjrHkiImS8vVe6P9I5dWwV09bL6C8Ho9474AOI=;
        b=hx63CDd5Rb7UfaUNGIES3eadmAhqks8Ildjhjo6/rMoIpaAK0k1CfLJotvJRl/FTrZ
         BcSvd3A7DV6I0Vnie64eVqZsURHfYuIS6QLDGgcMSqSTdDT7ysI9ytbpPJHVakC54BfV
         Eo+zsDnCjF1MD+wC0xeMlJpdl+F51R6sN7WiBiGYL6ekXnqg8hIhc8bSGARZCFw66E4u
         EMrVaPEtOm1Z/tbdrfZvoFH2xrHXRgTSSSPmsln6ikov/ppUJ5/D/cQ23CdqdhC4pQFW
         SRJU1OMhnTyDp1HqKvrkbH+4n9Hx6L+aMfKgiavNjIrqIB8xL1U0ZaNVPBg9xOVoJ6cY
         aS6g==
X-Gm-Message-State: ANhLgQ3Xerg4ACCZ34ve7tAflWTz7Qv8LTLmUISyFV8c48hFs/JmglTw
        At5GMqg0YByKTITgfg0Az9Ot0Q==
X-Google-Smtp-Source: ADFU+vvCjSes37GkD0wnSCc3gLjbYYbhHIAgGw/udMfNKdIx46Fzqm9iSWWsJ/4HNHBsMoEvWJvIBA==
X-Received: by 2002:adf:9bc4:: with SMTP id e4mr8282863wrc.341.1585214931982;
        Thu, 26 Mar 2020 02:28:51 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id i1sm2670313wrq.89.2020.03.26.02.28.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 02:28:51 -0700 (PDT)
Date:   Thu, 26 Mar 2020 10:28:50 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH v2 net-next 1/7] devlink: Add macro for "fw.api" to
 info_get cb.
Message-ID: <20200326092850.GS11304@nanopsycho.orion>
References: <1585204021-10317-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <1585204021-10317-2-git-send-email-vasundhara-v.volam@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1585204021-10317-2-git-send-email-vasundhara-v.volam@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Mar 26, 2020 at 07:26:58AM CET, vasundhara-v.volam@broadcom.com wrote:
>Add definition and documentation for the new generic info "fw.api".
>"fw.api" specifies the version of the software interfaces between
>driver and overall firmware.
>
>Cc: Jakub Kicinski <kuba@kernel.org>
>Cc: Jiri Pirko <jiri@mellanox.com>
>Cc: Jacob Keller <jacob.e.keller@intel.com>
>Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
>Signed-off-by: Michael Chan <michael.chan@broadcom.com>

Looks sane to me.

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
