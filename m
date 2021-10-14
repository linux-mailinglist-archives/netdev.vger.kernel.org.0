Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DAE042DB4D
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 16:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbhJNOUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 10:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231464AbhJNOUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 10:20:19 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6733BC061570
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 07:18:14 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id 77so5538813qkh.6
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 07:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:cc:content-transfer-encoding;
        bh=Dz4rSgFcLegLiqLcWfYC3HD3s4UuC4Wj0K7IgIY1HVo=;
        b=IlAV8M3TSpq5bL7XQyFBE3+igTgYJ4fG8xdMIjrR2lORyg/1YU4pE/VbCtMutrY5NF
         LnSSd6IP1yKraPY300n32FbXPqnS8hlYELj5Njje0W7LcMkwURc5gVywlGpB9a4PZgF6
         NxW8yFMER4fTBDKYkh+CWcaO6BDUsJO2eyuUWksWx+hvvHmjKlYStIUlDlk2oNXiv94W
         T6iMYbk0fz/e0sNGYCrJv3mGvgNeeuiOuOgv29b1fqpcZXoAl+qtzL19EyoS1PpUVN+A
         Q54F7U9q/hX2+YrHOxu0L/V1b7a0Ag/tU3ZzRcC/4lKNRr7Vd3CD/HY3vddJIblRRciF
         0kwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:cc:content-transfer-encoding;
        bh=Dz4rSgFcLegLiqLcWfYC3HD3s4UuC4Wj0K7IgIY1HVo=;
        b=uKP38rcVduXEJFYs+i6YLna4Qe/gYbC69/OmZ5Y0zxk4IOxXfQRWg2tMq7HABdcyZE
         C/HPJYjBWUN8o7VcpXPalCMtDzHyhtGxnAV9qqxTrzWTs/DaqwE5OS0MHMJA/uZywltA
         yRI6FTAzLcUlxwI/qSSTFeidX8O3RCURxP9k31+1+2xrmQszWFsPFdIDrcOxyT79ndX3
         G97J8pITJ4P2tHRc4uIl5nATocxOyY9s/uhiAdzIkfmtODi20woUY5Pg7m7L+EWZiEm9
         ghwWJU47T6WJxU7Sfx13OUdDX4M967AuX/N2Oq95PwN+16fPyhGUyAKgyMA1Z5ZbdiMs
         6BlA==
X-Gm-Message-State: AOAM5330C54sqxD7/sL9iO335pSRZdNE/ZUAKKDO4wfUC7HgeFf2boq+
        gBv+3FjfEpQn8tJ9U92IdFtSgnLrIl2jhA==
X-Google-Smtp-Source: ABdhPJxXFMSu2yrGFI7sulbd5XhuVrz5ShhuZBKiBvIuJN/0h0Av90reLDG6Hb3DXyeFklLPYncj2g==
X-Received: by 2002:a05:620a:1707:: with SMTP id az7mr4332252qkb.276.1634221093321;
        Thu, 14 Oct 2021 07:18:13 -0700 (PDT)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-33-142-112-185-132.dsl.bell.ca. [142.112.185.132])
        by smtp.googlemail.com with ESMTPSA id b13sm633612qtq.69.2021.10.14.07.18.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Oct 2021 07:18:12 -0700 (PDT)
Message-ID: <1fd8d0ac-ba8a-4836-59ab-0ed3b0321775@mojatatu.com>
Date:   Thu, 14 Oct 2021 10:18:12 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Content-Language: en-US
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Subject: Anybody else getting unsubscribed from the list?
Cc:     David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I was trying to catchup with the list and i noticed I
have stopped receiving emails since the 11th. I am leaning
towards my account being unsubscribed given i had to
resubscribe last time.

Anyone else experiencing the same problem?
And, yes - ive checked all of spam...

Who owns the management of the list these days so i can
reach out to them?

cheers,
jamal
