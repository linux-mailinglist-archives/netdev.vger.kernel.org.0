Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A529A28545B
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 00:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgJFWMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 18:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbgJFWMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 18:12:23 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79DCBC061755
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 15:12:23 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id m15so1926456pls.8
        for <netdev@vger.kernel.org>; Tue, 06 Oct 2020 15:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cQ5lpgy+JcnkPzTe7pdLgA5XrrWOQCrnTldGGGyu7Ow=;
        b=CHhmQORWqC7M3yvDUH70RT5re8nUVuNF0+QUcSoAxFA0wqiwskFBNwqxrTSj3c9Shx
         3VVXJc4AIqDtSVqxxUM5PPi18EKa1S8KqXwI+gHsIWRLToo9S/6WWzXFMIaIbNx97QKg
         j6n96CYbzj6SBKrGTJJSYxDw4m7JTjGfVOckCIvvX7iGPUZUqRBmCghDeSV4IK3/ZoQi
         RSKyORyZHdiI2DtswbfiqJ3EnPgDBzUc0s3U3GUgTHtPhyHwPUj2xam8XvP+bb0QnxPS
         KcG01eEHW33L3LQy9yBGAeP1j0MphrRL0hiscaPyZsKS4aaCtV5Bz3+VtifgCTfA1XQp
         mNTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cQ5lpgy+JcnkPzTe7pdLgA5XrrWOQCrnTldGGGyu7Ow=;
        b=pAmMGsomqiqFgea1sq4kIQjKgXFrkiNQTcMLm0nhRL5mCDZTmgJZvRy6Yg04iMxY5+
         Wn92YvXdxEYNX6b57sO3HlyhpIxubme2ZnLh7dEx+SBOc2bUnDx7ur1iaUuhVe6jeYE5
         6+LPGdB9jUyxK4LEMqanDd+TmXw7Rr8zgRYa4oKQUHEn9r4WH1IM/ELuDiwDSKzIY6vo
         7kQ3EGsyHt9NWN0/QR6/wqA5jMz7Dscu3peKSrCBf6T+h3lvmS8h3ze8DsFVVxYzJLZ3
         swlsG3bLhc2naV9qGgAo9pVBS4vdgwk7GNREE+T/aoPbLk9v9yK5wz8JR8aj/Kr/NN4j
         5IsA==
X-Gm-Message-State: AOAM532uMgxePR8YpHPsgg1Mz+OCO6H6Jep0lNr8nci88jo0VgtlmPn1
        vM8LEDeV8ixjPt/fOmCYCjzFcnWqREZ2iw==
X-Google-Smtp-Source: ABdhPJxGvnqB0imbPNfhd0zbZqjwVl4JQeRRgZa1pvTMkWAk1LM+dpjajqRs9Aa4UW2gxzmmcHveTw==
X-Received: by 2002:a17:902:a715:b029:d3:c2b4:bcee with SMTP id w21-20020a170902a715b02900d3c2b4bceemr70117plq.22.1602022342991;
        Tue, 06 Oct 2020 15:12:22 -0700 (PDT)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id o38sm164802pgb.12.2020.10.06.15.12.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 15:12:22 -0700 (PDT)
Date:   Tue, 6 Oct 2020 15:12:14 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [iproute2] ipntable: add missing ndts_table_fulls ntable stat
Message-ID: <20201006151214.43e4a909@hermes.local>
In-Reply-To: <20201002093428.2618907-1-eyal.birger@gmail.com>
References: <20201002093428.2618907-1-eyal.birger@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  2 Oct 2020 12:34:28 +0300
Eyal Birger <eyal.birger@gmail.com> wrote:

> Used for tracking neighbour table overflows.
> 
> Signed-off-by: Eyal Birger <eyal.birger@gmail.com>

Looks good, wonder why it wasn't there already.

Applied.
