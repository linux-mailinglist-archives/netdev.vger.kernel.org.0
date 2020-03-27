Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C18561958F0
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 15:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727548AbgC0O1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 10:27:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:52866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726656AbgC0O1M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 10:27:12 -0400
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5919E207FF;
        Fri, 27 Mar 2020 14:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585319231;
        bh=hD4cAlT39Vlqg/WzYLmXW0gi8KZ+OInRbLCxPG4TkAg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=yYtb3fpsxLMABkI77C9j2ZyUBFKQ9iCsDfJVjiNFECx3dLEkGrSU+8nM4dpShZVmy
         FcY+kR31nfpBBcWnJ2F6rQpYa3F+DgFJZ+jLcyD7FcJVib7y1Ym41WuDpg+UY23w4z
         issME7/jgpz62D0aCw8aCw7fOAcXeP94f+PbkfXM=
Received: by mail-qt1-f169.google.com with SMTP id c14so8688108qtp.0;
        Fri, 27 Mar 2020 07:27:11 -0700 (PDT)
X-Gm-Message-State: ANhLgQ25goE8IRv1uTg4JtWM4i4K9lz8Ojc658BwqP/W9T0AuheCMZQJ
        d6i+7ABjM0SlMPQ+ZvomGELym+2t0cVoQBAwjw==
X-Google-Smtp-Source: ADFU+vuijTQWskgOuHhXvkzKMDdfKJKhsSzMwtt9f7bvO1piVOayuh+2y8tfvMHs6N09tnSJkSCMoyGOatLe8FZ9haA=
X-Received: by 2002:ac8:18ab:: with SMTP id s40mr14342388qtj.224.1585319230429;
 Fri, 27 Mar 2020 07:27:10 -0700 (PDT)
MIME-Version: 1.0
References: <33fa622c263ad40a129dc2b8dd0111b40016bc17.1585316085.git.mchehab+huawei@kernel.org>
In-Reply-To: <33fa622c263ad40a129dc2b8dd0111b40016bc17.1585316085.git.mchehab+huawei@kernel.org>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Fri, 27 Mar 2020 08:26:58 -0600
X-Gmail-Original-Message-ID: <CAL_JsqLZQN253PDi-HXtP3s5CCg0OzaUK99onC9UjQWeVw3KYw@mail.gmail.com>
Message-ID: <CAL_JsqLZQN253PDi-HXtP3s5CCg0OzaUK99onC9UjQWeVw3KYw@mail.gmail.com>
Subject: Re: [PATCH] docs: dt: fix a broken reference for a file converted to json
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Marcel Holtmann <marcel@holtmann.org>,
        Simon Horman <simon.horman@netronome.com>,
        Harish Bandi <c-hbandi@codeaurora.org>,
        Venkata Lakshmi Narayana Gubba <gubbaven@codeaurora.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Rocky Liao <rjliao@codeaurora.org>,
        Matthias Brugger <mbrugger@suse.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 27, 2020 at 7:34 AM Mauro Carvalho Chehab
<mchehab+huawei@kernel.org> wrote:
>
> Changeset 32ced09d7903 ("dt-bindings: serial: Convert slave-device bindings to json-schema")
> moved a binding to json and updated the links. Yet, one link
> was forgotten.

It was not. There's a merge conflict, so I dropped it until after rc1.

>
> Update this one too.
>
> Fixes: 32ced09d7903 ("dt-bindings: serial: Convert slave-device bindings to json-schema")
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---
>  Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt b/Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt
> index beca6466d59a..d2202791c1d4 100644
> --- a/Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt
> +++ b/Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt
> @@ -29,7 +29,7 @@ Required properties for compatible string qcom,wcn399x-bt:
>
>  Optional properties for compatible string qcom,wcn399x-bt:
>
> - - max-speed: see Documentation/devicetree/bindings/serial/slave-device.txt
> + - max-speed: see Documentation/devicetree/bindings/serial/serial.yaml
>   - firmware-name: specify the name of nvm firmware to load
>   - clocks: clock provided to the controller
>
> --
> 2.25.1
>
