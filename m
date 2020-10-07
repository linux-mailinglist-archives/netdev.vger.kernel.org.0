Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88210285BF3
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 11:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbgJGJgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 05:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbgJGJgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 05:36:35 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E9BC061755
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 02:36:35 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id a23so497619ljp.5
        for <netdev@vger.kernel.org>; Wed, 07 Oct 2020 02:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=at6Slu7caP6r6MuR/pxVFga5/oQNMJKTeLYuZoWjeXw=;
        b=b8yoq45KLsYCpKlbDPXqg0PKklK/9XPqRT8HJ0bU9bQP6oAYafDxIMxYkkzNYiaUSz
         yNIH0cGsA9mF6Px3zXQlVN1iCOMHxr6whU/xWEPQWMoBYPWFd/IN/SXX+3+A0Uzz2cjg
         LUrUO5ahIClHQJELl+xrWsYTX8Wn9PPwSCAICV+tsQyI+zMcoBTQZHBjTiOWJpiQYrHq
         /LArZMrL00NLtzWyF9A/3zPgrrHgDrikyW1YYBYPWxKGNFMlJ86qb4fHyTSMYsHwkKv0
         NYGjy/GoXbp2yY2z8j48yCpnKBRNwKrxHsG1miAonTaaqb3oQZVAb4GqIG7Z+DwPsjpj
         TmcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=at6Slu7caP6r6MuR/pxVFga5/oQNMJKTeLYuZoWjeXw=;
        b=F3BSM2/z4zHYSFKo7sr9pNxbvAOhCZko9wP7v2N92WRpUXyB6YzR6mjgB/Qkl0ChmH
         aAVegJGyqFVTei1sXRSa4smy0FwsKoGaHSoYAotnSTuc8f4iQqL6LDaOYsJtcC9BZtuS
         Sq8k0nAoF7BlVgntRspnWKWoHK6C2tHG9qN3FSvXbVSjMIPKa3WQJ0TmNSC7VqPvDWMa
         SjkX5DKgwkupuyraqrfQFS2N8gVFJ83w+x5+x7Ue78QnsvMDl2r195OTpXRVazOZMRve
         be6mAyZzZ4RXeec29hUc5t0T3vvmumXns5jkj0mM4iWK/kXF/xXfExRPlYYjPWNXOdyh
         pcBA==
X-Gm-Message-State: AOAM533fALkUgo/AlUJndUY7pwpesIwRN9aoZJAUIZTrX8d9GiAbuELC
        ouYX/0Ol/ctrC1SXcpQOQDwdZVwQCMCDZjmEItjJCw==
X-Google-Smtp-Source: ABdhPJxMdxL+fHaSLpO3vK3yASxEsrJcC3kMJ2R39aH0+SqmgokuS6kFscI5tGmj/zmGwocE3uKsLczI5DnAh859RIQ=
X-Received: by 2002:a2e:4e01:: with SMTP id c1mr815254ljb.144.1602063393619;
 Wed, 07 Oct 2020 02:36:33 -0700 (PDT)
MIME-Version: 1.0
References: <20201006193453.4069-1-linus.walleij@linaro.org> <202010070626.DHqRvzc2-lkp@intel.com>
In-Reply-To: <202010070626.DHqRvzc2-lkp@intel.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 7 Oct 2020 11:36:22 +0200
Message-ID: <CACRpkdbgyjBX-6fk55DK1oXbBE5y1iSGb9-vRO9hvNAbpmpnoQ@mail.gmail.com>
Subject: Re: [net-next PATCH v2] net: dsa: rtl8366rb: Roof MTU for switch
To:     kernel test robot <lkp@intel.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>, kbuild-all@lists.01.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 7, 2020 at 12:19 AM kernel test robot <lkp@intel.com> wrote:

> I love your patch! Yet something to improve:
>
> [auto build test ERROR on net-next/master]

Ooops fixing syntax without checking semantics, will respin.

Yours,
Linus Walleij
