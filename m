Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B169D3487
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 01:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbfJJXoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 19:44:19 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:45629 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbfJJXoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 19:44:19 -0400
Received: by mail-qt1-f194.google.com with SMTP id c21so11263698qtj.12;
        Thu, 10 Oct 2019 16:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rcSn1vCJbuxn3bYcrpBbek84j13SuRZ8wCxvhMSzcKo=;
        b=X0eH7IQQtXwjhM8QAXI8Ra3VlUekFB08JwxVQoYgInpA6gxOxngSdH+5N97FE6Hydm
         L5Xszn63Ia83PwIrCpYoelxUL7RkSA+KGzefkV6FaTOKEEsvaKrQBRA7ka7KOg5sjqjO
         mnwXYklMvyUMK5/T7JvVAPTct+Jshn/6w+J1Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rcSn1vCJbuxn3bYcrpBbek84j13SuRZ8wCxvhMSzcKo=;
        b=Frtc8cydVRl/idPXZ1puJu98ANkPd0mkwpMn+G1zqAu5f/SRue04o99B2/AJAng6GN
         C3xZeF/4gA0q4AK8XEKnY33HRZc+q8Vzcv9EpCufB6fkT8ost3yIb2li3WzvE/zp+NvI
         6IarNSlT/nEwD3VO4BfDO6eAwDdbU/ZlobR5TGKv+0qTU7uGNaJ0dlsGcQlw1I7EMOxG
         MtjWzoudELxRKkae0cnxcnH0cJdfmpX2ZQnogRKafOLexW2/+r2xc3ot5ezzPD90gFYI
         FC87MIi7SE3DtYQtxKydHN8O1iWoTOR62s9vJDZ/iZhEeOFAvZq2UAWeXkSbhS4Bl/3U
         JyBQ==
X-Gm-Message-State: APjAAAX/xUb9DPw1Mn73A3O0ex7w2ZyQtj8890UjZzZBPr17G32vzTLy
        PKCGp17CNJmSPsVOSeFCWzj5f833NsF5JFeMzvE=
X-Google-Smtp-Source: APXvYqz0x1K+tlIiXgdr6o6qeGgBTJHPWg6le+hqBBQerv2MEmycmhWnHoMRBnpQ/FKEHxEfxoyzlX9H93uXVTfrgL4=
X-Received: by 2002:ac8:2e65:: with SMTP id s34mr13649429qta.169.1570751058435;
 Thu, 10 Oct 2019 16:44:18 -0700 (PDT)
MIME-Version: 1.0
References: <20191010020756.4198-1-andrew@aj.id.au> <20191010020756.4198-4-andrew@aj.id.au>
In-Reply-To: <20191010020756.4198-4-andrew@aj.id.au>
From:   Joel Stanley <joel@jms.id.au>
Date:   Thu, 10 Oct 2019 23:44:06 +0000
Message-ID: <CACPK8Xf8rEwCiDe1b+FgHQPscJYXuwKFzfrP1vmFeYde=uawyA@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] net: ftgmac100: Ungate RCLK for RMII on ASPEED MACs
To:     Andrew Jeffery <andrew@aj.id.au>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Oct 2019 at 02:07, Andrew Jeffery <andrew@aj.id.au> wrote:
>
> The 50MHz RCLK has to be enabled before the RMII interface will function.
>
> Signed-off-by: Andrew Jeffery <andrew@aj.id.au>

Reviewed-by: Joel Stanley <joel@jms.id.au>
