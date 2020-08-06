Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16E7123DDB0
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 19:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730429AbgHFRND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 13:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730415AbgHFRMw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 13:12:52 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D67C061574;
        Thu,  6 Aug 2020 10:12:52 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id x69so45670873qkb.1;
        Thu, 06 Aug 2020 10:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=bv/T+Cc8SWIHSFomrcPUqj51gKlivyi5zXcjJ51jfYA=;
        b=pxKukvBcJy0IGR5wO9U1XkvqCnEllThCx+g8batpLHQ/djdPKxh4X+5AKn+msb+IaD
         aLZJvehC2RwKRlhb+8fKHRc9QNS3xTIvsHx4D/BcHjYTQ66ssGt8KsbFNOFeA6wB14n3
         PV+UFd0ru5449KkKohwF1x/QBulhwxkNCRCJhRu+arGtAH6skh8SThI7DnKFY6vUcmRh
         vn7aT5Vsne8bhSThJFf0OE9vCkEL87adD8liGuEm2nk4sRnqdyKjklWaQ/G1bt5bLQsP
         3XBs0gfv8EW6tM/iN/sBiEvB7N9mT2RNHEZeFCOEmyw+wuvgkpA1XA19+JfT4e5SN2NI
         3JJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bv/T+Cc8SWIHSFomrcPUqj51gKlivyi5zXcjJ51jfYA=;
        b=F5OejOp/MvnHPJX2Gna/K+HTOpAkobwRjher5IRKK19ZwlEZkI67d4sJk2cbh6XbAW
         K8AUWQ3LPpwjrN3RIv6H7sBg4IOxtKroebb4h/GfaHQ8bQTLkAs+oZpaFTPprV+AbkQI
         KvJ+qBhcbSkr9ObdSoqB1cJFpS5nA+Zcztm9jPv4FZ2T29UXb4K0ah5IYHg4Lq3ku//9
         kscyBFdhcDKNF76J5kaihhonShN9b32erCX1xezC/qD8AnmlX1VrHkCb1ZSu4BFYXrJf
         0kyznfageg2seF6y9ga+ot0bzFyuErBRsIDOBAF+acMyG+oj2ti6h8pwEUHPLZfnY7x+
         I86Q==
X-Gm-Message-State: AOAM531T6FM6r66RrHKHdCRuYsXCleRyxxzIRLclTYmbKbNScAXxDESm
        biWaz3b1o7rT6qQ4kijErwc=
X-Google-Smtp-Source: ABdhPJxbCmMDgw2zfE8Um4DHcNr0p+bdIQnDOUq/x/Xj3+mqto87NHzUvR0Xsl9fq0sqV7eNkIjqoQ==
X-Received: by 2002:a37:9b15:: with SMTP id d21mr9933406qke.9.1596733967564;
        Thu, 06 Aug 2020 10:12:47 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:7c83:3cd:b611:a456? ([2601:282:803:7700:7c83:3cd:b611:a456])
        by smtp.googlemail.com with ESMTPSA id x3sm4586312qkx.3.2020.08.06.10.12.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2020 10:12:46 -0700 (PDT)
Subject: Re: [net-next iproute2 PATCH v3 1/2] iplink: hsr: add support for
 creating PRP device similar to HSR
To:     Murali Karicheri <m-karicheri2@ti.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        nsekhar@ti.com, grygorii.strashko@ti.com, vinicius.gomes@intel.com,
        stephen@networkplumber.org, kuznet@ms2.inr.ac.ru
References: <20200717152205.826-1-m-karicheri2@ti.com>
 <e6ac459e-b81c-48ee-d82c-36a533e2aa29@ti.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <6632128c-1c4b-4538-81a9-48dd752c8ab3@gmail.com>
Date:   Thu, 6 Aug 2020 11:12:44 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <e6ac459e-b81c-48ee-d82c-36a533e2aa29@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/6/20 10:04 AM, Murali Karicheri wrote:
> that the maintainers are different than the netdev maintainers. My bad.
> The PRP driver support in kernel is merged by Dave to net-next and this
> iproute2 change has to go with it. So please review and apply this if it
> looks good. The kernel part merged is at

there was a long delay between iproute2 and commit to net-next. You need
to re-send the iproute2 patches.
