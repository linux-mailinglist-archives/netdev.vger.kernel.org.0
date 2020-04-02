Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA5419C637
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 17:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389519AbgDBPoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 11:44:38 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:41039 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389458AbgDBPoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 11:44:38 -0400
Received: by mail-qt1-f194.google.com with SMTP id i3so3618029qtv.8
        for <netdev@vger.kernel.org>; Thu, 02 Apr 2020 08:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=TLNDcmEugJyCTREx8LMvzFodlzrJq+ZkY4LgYUCwf/g=;
        b=u4Ssz7Pp7EGBFnoV5Nb+fa1b7zjwL/iAnBFZOTylrNtUHqtcV6jA8/NRDHjTD2OwTF
         hDjmjHVHuQK7DB4QlQRcGpgOgH5B9TsgKoRp7y/xfRQpw9DAKrHSxqWrInhqfqcxZotp
         me/PmdxWvtqawdxTXUoVWIL9YNSn0D2GUhcVhpUh9B6qbGYIaAV6saHErJAoMszx/297
         5jiY9S3hP/laHzQvEGMDe8uSF2rNNphLnMy+QWzCBhIrsYRm7bHP/R+PNTBRXU04bMf2
         FLsMfFdkLm924oIjyBrhYgdRrHbzdjFrgboh7qOr4KyG9r7qt1VpDk/7NnymHHJ3GrCM
         1UuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=TLNDcmEugJyCTREx8LMvzFodlzrJq+ZkY4LgYUCwf/g=;
        b=FWNSejvfW/0t8401tTgbZy9InX+a8ZuDU8/z7Sq93X8SxHCecI0t/QuNA/157Kzq/F
         3sO8GPM0rgSnsKBkcXRCjuhQFyRBP9In605/mY/Hr+I3c1+uZP19EBeuKXriXmfZqzMO
         mbfH8vacP+TfFMkhbxkWvcCFnI1AOGC6Ogc2Kzx2S7kuAUJS0JD4FSkl05f+tQ49v0+Z
         tbotBvTYt/6IAiuGx2fmJdl5RfUI4T33v2njhDlAumM9ISUj+d6upesUIX3TZ13t80iP
         em8Itx85CmzZQwe6NJ1uwxEa//KXFgZtIMxI/4zr/AaGx82zHo1BsWTOxH/3qbLmpy6d
         116g==
X-Gm-Message-State: AGi0PuYGGsgAwDuSzZnWvgs5vbHOYDVmkIEzulj+MTpkrdpzpInW2QDf
        kP4P/HvSc4g5zzY+ACHrmKc=
X-Google-Smtp-Source: APiQypKU7exO/63Xm5noeunxGObNEu3zNMCzGXF96xebZXvdMe/wTklIeVs+tb6qKsLWpDcy7VgCCw==
X-Received: by 2002:ac8:39c6:: with SMTP id v64mr3610184qte.344.1585842277298;
        Thu, 02 Apr 2020 08:44:37 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id q24sm3987326qtk.45.2020.04.02.08.44.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 08:44:36 -0700 (PDT)
Date:   Thu, 2 Apr 2020 11:44:35 -0400
Message-ID: <20200402114435.GB1775094@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Jason Yan <yanaijie@huawei.com>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Jason Yan <yanaijie@huawei.com>
Subject: Re: [PATCH] net: dsa: make dsa_bridge_mtu_normalization() static
In-Reply-To: <20200402071505.9999-1-yanaijie@huawei.com>
References: <20200402071505.9999-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2 Apr 2020 15:15:05 +0800, Jason Yan <yanaijie@huawei.com> wrote:
> Fix the following sparse warning:
> 
> net/dsa/slave.c:1341:6: warning: symbol 'dsa_bridge_mtu_normalization'
> was not declared. Should it be static?
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Jason Yan <yanaijie@huawei.com>

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
