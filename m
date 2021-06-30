Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 616C73B876A
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 19:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232428AbhF3RKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 13:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbhF3RKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 13:10:50 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C09CBC061756;
        Wed, 30 Jun 2021 10:08:20 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id i6so3090035pfq.1;
        Wed, 30 Jun 2021 10:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=1HBV1uKRWTsNwDEannggYTE19vMCI0GvXIoggQerjfo=;
        b=WIMvIPloDZTpahPeqFmor4vATcCXK8QXaKFWq69VfNPlSP/Bl31QwU3tcYP25tbHaZ
         ny20NJQwppb3QKU+5u3gFVOGc7iUmAfarFbimqT8pA4EiseS5p1cfy0LO/q1AvCqvhRv
         VPn7wDWraImETve0JaP23wbu0e1BydSxaf9n2ZxtVg9pyhwM3oYUVm5D0lVjTGKl42pO
         4U4YZSaU6H7DysP2hIDD2om+dUx4Coz9JCoI3DiSSaguomfWkWC2htDauwFUAsjsEpdo
         dC+65YKS1PBYjqwiFpSuL/UncZOrh28xS2u7EzGMxmPlIw3bVMN/wVV4vWGHSeQysnOD
         vHDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=1HBV1uKRWTsNwDEannggYTE19vMCI0GvXIoggQerjfo=;
        b=eiUJSupC2+YBcFwwTbi3Hfml7verslWw8G0npOt4S3rKfR66sUsiCEpblv5AZjrVZc
         cLTyYKOvQiCYsgGzYAd5I2cYL1rj3Tsn/j3mVBTdM/cn6SHOt1amebBOjTzcDSlVfQBD
         uYXHK6AQtzc4IY0/aCg93iQAx8Hlm4CvFNQ1Quzd79ej3OjHjjuu2E51g/VYVF6M/Zat
         FDc0ju0m3ZxYb0e4KAmwafQqeO3fPjl2UpkT/q5MFVzgq/Q9NWKP60MskEqbU40qI56+
         YkChYLzq9l0eBeA5khJGUoP2iPZUOkmYZfFnksDBeCNPa6g041nZQu+bCjsGjNRSaH8M
         J1fw==
X-Gm-Message-State: AOAM531mncUn+LgQ5tufGfsorNWbRj7lrxuIcBIQu09Qba6T04jnAoJw
        FZAkKmM+qdOL/IqaObB5BDU=
X-Google-Smtp-Source: ABdhPJzc8nOKPw7G3gyo5Vpb2zW+zlXjnqq+Hmx2jTQYGUcSzdNeQz3IkoiOBdwEpJNJ+0Usj5AEhQ==
X-Received: by 2002:a65:6a45:: with SMTP id o5mr35427214pgu.409.1625072900209;
        Wed, 30 Jun 2021 10:08:20 -0700 (PDT)
Received: from horizon.localdomain ([2001:1284:f013:9971:da8:e275:5330:286f])
        by smtp.gmail.com with ESMTPSA id q12sm17981065pfj.220.2021.06.30.10.08.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 10:08:19 -0700 (PDT)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id BAD9FC6362; Wed, 30 Jun 2021 14:08:17 -0300 (-03)
Date:   Wed, 30 Jun 2021 14:08:17 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, linux-sctp@vger.kernel.org
Subject: Re: [PATCH net-next] sctp: move 198 addresses from unusable to
 private scope
Message-ID: <YNylAVJ+OHi1e7GV@horizon.localdomain>
References: <c3f8dfcf952ebfd1ebe0108fc13aacedbad38e99.1625024048.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c3f8dfcf952ebfd1ebe0108fc13aacedbad38e99.1625024048.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 29, 2021 at 11:34:08PM -0400, Xin Long wrote:
> The doc draft-stewart-tsvwg-sctp-ipv4-00 that restricts 198 addresses
> was never published. These addresses as private addresses should be
> allowed to use in SCTP.
> 
> As Michael Tuexen suggested, this patch is to move 198 addresses from
> unusable to private scope.
> 
> Reported-by: Sérgio <surkamp@gmail.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
