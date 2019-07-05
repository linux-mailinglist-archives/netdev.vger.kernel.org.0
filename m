Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6DDA60B15
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 19:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbfGERaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 13:30:01 -0400
Received: from mail-qk1-f181.google.com ([209.85.222.181]:33159 "EHLO
        mail-qk1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727962AbfGERaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 13:30:01 -0400
Received: by mail-qk1-f181.google.com with SMTP id r6so8448715qkc.0
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 10:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=dsq1XoSH1bXMiLenJUvhB3MIycIH4BSqoXC0jOmalQQ=;
        b=fjXjqSwc5PaS+nqxEhNR62DGHBFoFKic4e7DfMEyeKOBCsl97W+y8IuBKva6ybTNfM
         mDrfOn63GNpPocOcZn2dKGBaZgKVVvEI/A1ciAeJcPSo7QLe2AW0Vt6x+HVcZq4Ky2WC
         zezUZscpNH6CKqWlL6dIwrGYu+zh0O/VkHRNtcTqgJvjZENpdXMG/Kx1NDj/ExLCC4L/
         pf1QTHh2joL2yANP/cXBN3ddM2Ri/hNudXPpbjHoyz2LEA3jJHXVJh15Cf5hhM9BWC7t
         xEKlIiZFx48x2cRij0fv90NzKSb4Buy9dveziaPiWzeYKAv5LYTk7KV6MC8oIor4e3q7
         Kkbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=dsq1XoSH1bXMiLenJUvhB3MIycIH4BSqoXC0jOmalQQ=;
        b=LbPILrwKujljruqyMUUEo+s7rNPgAtNXTGN+ts9QxNCHov8u4LkYEMUS3aFseVzztl
         ruhxsuYqQqSx9Q6ZqvgiNxdiGzGel3UbQcdJ4d+r5IIHH56qdo1wTJTmOON4+FpOris8
         hGESB8Mr5jTz3YUNFdS7wTlQfH5n9Kd8kL9eXGSNDbH/P9QWJ/G+kbBHFzS1bCGmFq8R
         RsT/FA8WfkDZ7DLm4NL0AxY4MbJ1SKnuJTKphC45Ov7NRhJRKYPLQYuFtc71VzCL2Kwg
         gL22jEs1TcgwkpmqcxJ/T1NWCMXoYaysaYq0aaDRvDl5r/DDdidRaIDhmmeBvmS3Yd08
         c7oA==
X-Gm-Message-State: APjAAAXUqUMt9OZBu4WoGMjAf2dHybAsgdBP3iY5rT155okMm/RKz1wB
        lwCxCXmdVYgUBYK+Asqg2b4=
X-Google-Smtp-Source: APXvYqzVePVRmBQJsiB2hsbduOgJM0feS/DXxK4NSA4fs804eAhtgrfzzhIqJENVCKalXg164Zp1lw==
X-Received: by 2002:a37:e40a:: with SMTP id y10mr4005972qkf.134.1562347799777;
        Fri, 05 Jul 2019 10:29:59 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id f26sm4792500qtf.44.2019.07.05.10.29.58
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 05 Jul 2019 10:29:58 -0700 (PDT)
Date:   Fri, 5 Jul 2019 13:29:57 -0400
Message-ID: <20190705132957.GB6495@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     vtolkm@gmail.com
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: loss of connectivity after enabling vlan_filtering
In-Reply-To: <53bd8ffc-1c0a-334d-67d5-3a74b76670e8@gmail.com>
References: <e5252bf0-f9c1-3e40-aebd-8c091dbb3e64@gmail.com>
 <20190629224927.GA26554@lunn.ch>
 <6226b473-b232-e1d3-40e9-18d118dd82c4@gmail.com>
 <20190629231119.GC26554@lunn.ch>
 <53bd8ffc-1c0a-334d-67d5-3a74b76670e8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 30 Jun 2019 01:23:02 +0200, vtolkm@googlemail.com wrote:
> A simple soul might infer that mv88e6xxx includes MV88E6060, at least
> that happened to me apparently (being said simpleton).

I agree that is confusing, that is why I don't like the 'xxx' naming
convention in general, found in many drivers. I'd prefer to stick with a
reference model, or product category, like soho in this case. But it was
initially written like this, so no reason to change its name now. I still
plan to merge mv88e6060 into mv88e6xxx, but it is unfortunately low priority
because I still don't have a platform with a 88E6060 on it.

Thanks,

	Vivien
