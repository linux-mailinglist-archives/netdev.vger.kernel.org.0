Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9B8364AF1
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 22:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242037AbhDSUDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 16:03:10 -0400
Received: from mail-pl1-f178.google.com ([209.85.214.178]:37560 "EHLO
        mail-pl1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbhDSUDI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 16:03:08 -0400
Received: by mail-pl1-f178.google.com with SMTP id h20so18379974plr.4;
        Mon, 19 Apr 2021 13:02:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uWrTUKdJjgaCGLW+RH2C2+Z+PPmsZG/+0Dq0dsG+zow=;
        b=dWLvI6fWoGLKym/locI3WPka9Gho+I2Q6+PrnV0JApn07217ibgElOWo8oBBXoKk5l
         a1/mBs+fgI4gu3fMIEb38XXGuZOh/xaoeFdJ/OYNcCWTr3pBmJLxmxXdMXt5vjT2YME7
         DuOT0KEHyHmkkJaIynfOkOaN9QnMcHlkIOmC/cRBx+XerRid/iM/XoHNI4jm2n1YRcEu
         /rDbcD3eS595C5i1nSQmDGYwc6Boanbvke50G+VX6VSIU6Mth9gV2Cs/nf9wE590jjhz
         MNe6b2urozeMU5aBkN4IO+7TQKxRNxMCGPLUjs/d4c4rDdqDyj663swWNZPMzSaTqt5k
         ANuw==
X-Gm-Message-State: AOAM533MFR3YL7lRVtHru1TjTxEJuiE9wwXAtt9iR6i2aJ3nW2ucIn0E
        Yznve0CAHNwA2wtptgTww3l7l/p1Gis=
X-Google-Smtp-Source: ABdhPJwDuR0gpQkAv7V+r4Zvgot2L+HjIAgrHYqURMsfM+UL6bXEu18tWhk+41d18aHmRZYwGsiWTw==
X-Received: by 2002:a17:90a:17a3:: with SMTP id q32mr862460pja.224.1618862557137;
        Mon, 19 Apr 2021 13:02:37 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:e7f5:59ce:2145:6158? ([2601:647:4000:d7:e7f5:59ce:2145:6158])
        by smtp.gmail.com with ESMTPSA id z5sm5065159pff.191.2021.04.19.13.02.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Apr 2021 13:02:36 -0700 (PDT)
Subject: Re: [PATCH 1/2] workqueue: Have 'alloc_workqueue()' like macros
 accept a format specifier
To:     Marion et Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        tj@kernel.org, jiangshanlai@gmail.com, saeedm@nvidia.com,
        leon@kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <cover.1618780558.git.christophe.jaillet@wanadoo.fr>
 <ae88f6c2c613d17bc1a56692cfa4f960dbc723d2.1618780558.git.christophe.jaillet@wanadoo.fr>
 <042f5fff-5faf-f3c5-0819-b8c8d766ede6@acm.org>
 <1032428026.331.1618814178946.JavaMail.www@wwinf2229>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <40c21bfe-e304-230d-b319-b98063347b8b@acm.org>
Date:   Mon, 19 Apr 2021 13:02:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <1032428026.331.1618814178946.JavaMail.www@wwinf2229>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/18/21 11:36 PM, Marion et Christophe JAILLET wrote:
> The list in To: is the one given by get_maintainer.pl. Usualy, I only
> put the ML in Cc: I've run the script on the 2 patches of the serie
> and merged the 2 lists. Everyone is in the To: of the cover letter
> and of the 2 patches.
> 
> If Théo is "Tejun Heo" (  (maintainer:WORKQUEUE) ), he is already in
> the To: line.
Linus wants to see a "Cc: ${maintainer}" tag in patches that he receives
from a maintainer and that modify another subsystem than the subsystem
maintained by that maintainer.

Thanks,

Bart.
