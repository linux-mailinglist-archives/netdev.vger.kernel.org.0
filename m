Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 811C9218B88
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 17:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730327AbgGHPlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 11:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729858AbgGHPlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 11:41:07 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11B5FC061A0B;
        Wed,  8 Jul 2020 08:41:07 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id r22so41897453qke.13;
        Wed, 08 Jul 2020 08:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=yHkGe9wjHgOEtbpHhNdkJSv+6hwZByVOWr17Q2Z241U=;
        b=bNl/0bL+GOk6ZzfrDdn1WFra/5RnQmcIsf3AAtJjRs8iDhOBtMXLvpilER4rkqZg7n
         M9LGFKv301pVWGBxzAOemWWZRhzDnNEK0L/ZF5V+t+O8/pOj+Q5rNsi6QvRV+8B6V3B0
         95KzUOBtlWgtigESsfauvkUA35x5PevBc+bRFKZQ7v3XwQW+S+BFe48tes99rQhnKX8C
         7Y0voMNaNvcX3qFO6CFfn64TJZ4oSKkwkv4AFkoT2LCmodJ5wjCfp1vtLbkCt60N6FyV
         V77knJEDUfNLYJtZdAFAz9oVxVM5jrr1hPnrrGaJGt3bdR2YZRbC849bBwnOhX+POyQ6
         /TeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=yHkGe9wjHgOEtbpHhNdkJSv+6hwZByVOWr17Q2Z241U=;
        b=WlfHqUniIJiaN6HjfiB2tZJN2zKVNbFm8H9y1cMxkiROtFe5+OSQtsMipDEOlthY9c
         GKhpjOFaG1JSbLCliO5kzwt72KLWKszuvZXXB81HsgqhuT7uOkhw7vzN/wzDkdme+52H
         5MMvG4ppfAWd2awD5oxOKg1rc+4Er1FkxnJ7gQQCsBIrfEAMWoMyKaEz7RWfyUeXLhDm
         K4JlzyT4YczV2q16SFBj+h8a3eHh6NthhrOW15fWMJZssd2iqnysb3jrGSjKvlqcMUVi
         hMWBUVZIGjNxvrxmaGRzxucY9M3S8Psx/hxQ9ehSNpo6RxEtwgEJoqjtB876Qbz/LqcV
         VKjg==
X-Gm-Message-State: AOAM530Gay1HehTGLUA/4iNs0wseZVto1pG4jnhghCIsS6u3c/nF8a+d
        wSxu0kf9uK9Lkco84fjoRMUEwVxb
X-Google-Smtp-Source: ABdhPJw6pyGrbWunAJld3V7Mvmy3XFozTAadZO6GTjXvlYgGuGyO0M1pcIi5kA72x5RVMwJGi0wnag==
X-Received: by 2002:a05:620a:a1d:: with SMTP id i29mr56323704qka.29.1594222866259;
        Wed, 08 Jul 2020 08:41:06 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id 19sm188119qke.44.2020.07.08.08.41.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 08:41:05 -0700 (PDT)
Date:   Wed, 8 Jul 2020 11:41:04 -0400
Message-ID: <20200708114104.GD45024@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dsa: loop: Print when registration is
 successful
In-Reply-To: <20200708044513.91534-1-f.fainelli@gmail.com>
References: <20200708044513.91534-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  7 Jul 2020 21:45:13 -0700, Florian Fainelli <f.fainelli@gmail.com> wrote:
> We have a number of error conditions that can lead to the driver not
> probing successfully, move the print when we are sure
> dsa_register_switch() has suceeded. This avoids repeated prints in case
> of probe deferral for instance.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
