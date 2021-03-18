Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB73E340AC0
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 17:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbhCRQ4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 12:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbhCRQ4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 12:56:24 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85BE9C06174A;
        Thu, 18 Mar 2021 09:56:21 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id e8so3009131iok.5;
        Thu, 18 Mar 2021 09:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dDE2Pj6zPBoLkTC6ITLinz5e4ZGgBzK1S0hNUB7Kgo4=;
        b=Gq+RnpKwjwSwpl/BhBUphQ1mCiavUToGuFeB9BzjbGwcjLaLd5SNOQT+bhqiZzjNxY
         aewiHjutZMxQMcWTyC+Jghwpnq6zu8zJlWfUGi6yA1z6LhAbKRfjsi3iRFAkDiVIxTer
         uHgi3lOVIjyoZtBpfPwo4Uur99xNj8hB1YS9CZUxlTSOskcRrDyWfFBcc9QhVctgN+1h
         DrJJMrrPAlDD/9hTiDVwpsqXhEG3YWzX4H6Uifj6d7flnlI8Bu7xvosdrnx+m2fyHctk
         n1m4nYzzOwdkiYdNlWm00aWXKzB4Z+wKWJIoR87momxAcDkXf7LNQ+GVC1Jj8bEPYCFp
         ohIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dDE2Pj6zPBoLkTC6ITLinz5e4ZGgBzK1S0hNUB7Kgo4=;
        b=WmOBTbefH6Kg2evVyepMkYraAnfHA51939zOH9G7hRBp1CZONArRpJa1bUCtEE888D
         NvPIvTZ8gBKalhKdGxuSlb3PTFkQSFFEcK4bWLFLONX0bWFttSQ1TEhTOJQbZUhPal7E
         q4kIhyPUt1c7fSyZNeBiZvGWrtBLaAyvzyVhYS2NldCDtyWGqnnYUhZ4CWZWVZ5NvxeJ
         64GF7uCA4lmaqUCZ4tWMnFttl9vfaC8jG+tyR8Z51OEttsYp2aR/96YgPavf1ymjSMDD
         LvZfwUh7gzvfS8u3ZhKShNzHzV05ig1AgTDFTH9eVb6VbeIqeTLfipXRRj4XBDfOxtCY
         BKww==
X-Gm-Message-State: AOAM532K9C1ey++y5Ua80QDsaMwcILK1g1ROPzXmXFLFa9iHDLkkwYtn
        aewpDUw3Y46XBHf5C9xNOZnvVQ99vYGza/p4PJg=
X-Google-Smtp-Source: ABdhPJyuhwEiD1aXPEVMyywdX8pbLTjaBm2ZyriSZhM/4G5K8OGRsCWc/5Ge+QVS/r/TJrW3eRr4VTuT/5fTTCiurSM=
X-Received: by 2002:a05:6638:359:: with SMTP id x25mr7955573jap.136.1616086580921;
 Thu, 18 Mar 2021 09:56:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210312003318.3273536-1-bjorn.andersson@linaro.org>
In-Reply-To: <20210312003318.3273536-1-bjorn.andersson@linaro.org>
From:   Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Date:   Thu, 18 Mar 2021 10:56:10 -0600
Message-ID: <CAOCk7Nq5B=TKh40wseAdnjGufcXuMRkc-e1GMsKDvZ-T7NfPGg@mail.gmail.com>
Subject: Re: [PATCH 0/5] qcom: wcnss: Allow overriding firmware form DT
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Andy Gross <agross@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Bryan O'Donoghue" <bryan.odonoghue@linaro.org>,
        MSM <linux-arm-msm@vger.kernel.org>,
        DTML <devicetree@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, wcn36xx@lists.infradead.org,
        "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

form -> from in the subject?

On Thu, Mar 11, 2021 at 5:34 PM Bjorn Andersson
<bjorn.andersson@linaro.org> wrote:
>
> The wireless subsystem found in Qualcomm MSM8974 and MSM8916 among others needs
> platform-, and perhaps even board-, specific firmware. Add support for
> providing this in devicetree.
