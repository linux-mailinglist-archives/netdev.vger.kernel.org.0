Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47C7319053A
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 06:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbgCXFeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 01:34:12 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45996 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725923AbgCXFeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 01:34:09 -0400
Received: by mail-pf1-f196.google.com with SMTP id j10so8721956pfi.12
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 22:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/TSTUAS7pvP0ZmRkI5IZvXuFAdhabZBDiE+44x81ou8=;
        b=ljrX+nzB2f3s76SBq9xehg+/86QsQkGMnIcSoYGsEbZa7O8l06KpvQs/FF5BMctmtL
         mrEflGYwhfaLEK3EDeOTjWAMQWrjqfh9NPYq9yON4sVXTWqXM+Iceg9/797A0I5e89qT
         mnPRpe0yvfHOvR7jQlWZBuB7+wAqCW8DOvXj2Z4nk2/xvQTNB6kNQ6ko9cQEQbtbQ6JF
         oPMlyINi0QmmPZOMAea/auJ8fCBCTrPSjJ5ZePOaGazbmA5Ozs+UM65slt/JhpEIHzwD
         j7D1qK1VSW2wg2UoQnUia+vKzkiVgcDDSFlIBUQrIji8z77ynhThUyhFshMMLf+AzDOY
         sIcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/TSTUAS7pvP0ZmRkI5IZvXuFAdhabZBDiE+44x81ou8=;
        b=DFzJNLXkC/zvKJDxWtMha4YU8A/rrfMu/pNZcqTjn8Y13hhO7irJoiauqH8ejstO4Y
         E4AAGB0uJRvd3w2ScdCRT6Wt6R2m3cmtqxlkMrhAUQuH6MApUjXyVippFLuiK3NiI062
         5Bjqxe32ghe0j/ugV0Dkz8an+q3fCqO1fwOOeka3Pv6/jY7RAfBdlvdULpGyJOxW9+m0
         YzRR1RzxeybGolarmKlX9aS9PdK/cJgaq1A9T19eoEeucDkBm2pxvBxOxDosxoQH83CV
         6Lfd/1TEbEKazOXL8wqTqXvlEleas9J9vlP9jm2m1nH2t0qslFcJpDZhHa3n4iQnTlIM
         pNrg==
X-Gm-Message-State: ANhLgQ36ETcukiqPNXCv2+qnxCnswtorHCg5gmJmm0YVkNKsFzceTaaF
        P/T2lnYVe/MWYI3Hzv7nd4jC
X-Google-Smtp-Source: ADFU+vvV0RUr88miCiQV1V7USfVHQnRUiV1da952qkZQH9yh+rNWjmRGD4aM1dM2OiD4dtIoOuuDfQ==
X-Received: by 2002:a62:e107:: with SMTP id q7mr11066372pfh.190.1585028047098;
        Mon, 23 Mar 2020 22:34:07 -0700 (PDT)
Received: from Mani-XPS-13-9360 ([2409:4072:59b:91e:2dd6:dffe:3569:b473])
        by smtp.gmail.com with ESMTPSA id z12sm16163241pfj.144.2020.03.23.22.34.00
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 23 Mar 2020 22:34:06 -0700 (PDT)
Date:   Tue, 24 Mar 2020 11:03:58 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     gregkh@linuxfoundation.org, davem@davemloft.net,
        smohanad@codeaurora.org, jhugo@codeaurora.org,
        bjorn.andersson@linaro.org, hemantk@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 7/7] net: qrtr: Do not depend on ARCH_QCOM
Message-ID: <20200324053358.GA11834@Mani-XPS-13-9360>
References: <20200323123102.13992-1-manivannan.sadhasivam@linaro.org>
 <20200323123102.13992-8-manivannan.sadhasivam@linaro.org>
 <87lfnravao.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lfnravao.fsf@kamboji.qca.qualcomm.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 23, 2020 at 06:30:07PM +0200, Kalle Valo wrote:
> Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org> writes:
> 
> > IPC Router protocol is also used by external modems for exchanging the QMI
> > messages. Hence, it doesn't always depend on Qualcomm platforms. One such
> > instance is the QCA6390 modem connected to x86 machine.
> 
> QCA6390 is not a modem, it's a Wi-Fi 6 (802.11ax) device :)
> 

Ah, yes ;) Will fix it in next revision.

Thanks,
Mani

> -- 
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
