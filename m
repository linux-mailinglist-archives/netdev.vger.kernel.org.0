Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E868D3AAA33
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 06:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbhFQEjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 00:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbhFQEjq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 00:39:46 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08E8C06175F
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 21:37:39 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id p15so6280887ybe.6
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 21:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PV3B1kEbMQAVSf9mnZtBQZPIM72+Ol+M0u8hmrXWp64=;
        b=Azl2D9EPJKy0vmXcUIFph4httN21NjRT3wWT9WuifrD4ZdTO5Vmje1ky/fGYu5cJYa
         Z+Q+z4amhYagV92mV4exhn/kB0zPfoX+U7Z9inNZQxFWRRwOK4RA/MC3UNSz34CgtCs8
         2RatGoQQDlVRiwdew3uq1PGDmmY/FfRkRrcRY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PV3B1kEbMQAVSf9mnZtBQZPIM72+Ol+M0u8hmrXWp64=;
        b=KWZZxqGm5IWEoHlsv7vOL8Tzchsh/+cuUvse7Ptz2Ip3us1PHwaGIpp58msVykt5bd
         3TPaob2/5m7bWfJVJnnBcOqNXhe42380B1IIFnEf75RrYDuETLfkb2B6SpkfEIcFpE+1
         oE/RbOztx5yUzAVGLJzplDhT29fl+Mrawn9FNKcTOtuR1uOJM7US2T6wewjYJv29FT8Y
         CtTGZIy9IjDjzzZrNH12Rz9XgClfzC4AyJ+B/3Ttojpe0YruzckFgF4ROBkCqE+No6C7
         Z1ZhNKNzCkeTASpF+rOwGiuCrPjibfL+u504QHPscuk3yyvnWXd6wgRzn+tBDfD65C/d
         PUJA==
X-Gm-Message-State: AOAM532pqOWxx4bHZG/qmQeKJ5hMm6WaIQ0mOUc5UdaCjULkwxPFKJOw
        GIkCVcUcCpXPMxzGBUFDsiOPMITz8CLdgT5Kznp94w==
X-Google-Smtp-Source: ABdhPJwWxuCzleTufw0dSETXBzl65JMmS+vhUStPnf5U1lU+cZdyo6qk7pPiSMIbyrPNiC6M1a79pZMGfgGGQrwenBQ=
X-Received: by 2002:a25:7445:: with SMTP id p66mr3492127ybc.99.1623904658541;
 Wed, 16 Jun 2021 21:37:38 -0700 (PDT)
MIME-Version: 1.0
References: <971dd676b5f6a9986c5b4b0c85cf14fa667d53a2.1623868840.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <971dd676b5f6a9986c5b4b0c85cf14fa667d53a2.1623868840.git.christophe.jaillet@wanadoo.fr>
From:   Somnath Kotur <somnath.kotur@broadcom.com>
Date:   Thu, 17 Jun 2021 10:07:27 +0530
Message-ID: <CAOBf=msiqGHTkDosQhtsWnuprgV0uQ-LjrWnVruOSV2M8rznAQ@mail.gmail.com>
Subject: Re: [PATCH] be2net: Fix an error handling path in 'be_probe()'
To:     christophe.jaillet@wanadoo.fr
Cc:     Ajit Kumar Khaparde <ajit.khaparde@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        davem@davemloft.net, kuba@kernel.org, sathya.perla@emulex.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000058fe7e05c4eec46b"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000058fe7e05c4eec46b
Content-Type: text/plain; charset="UTF-8"

On Thu, Jun 17, 2021 at 12:13 AM Christophe JAILLET
<christophe.jaillet@wanadoo.fr> wrote:
>
> If an error occurs after a 'pci_enable_pcie_error_reporting()' call, it
> must be undone by a corresponding 'pci_disable_pcie_error_reporting()'
> call, as already done in the remove function.
>
> Fixes: d6b6d9877878 ("be2net: use PCIe AER capability")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/net/ethernet/emulex/benet/be_main.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
> index b6eba29d8e99..7968568bbe21 100644
> --- a/drivers/net/ethernet/emulex/benet/be_main.c
> +++ b/drivers/net/ethernet/emulex/benet/be_main.c
> @@ -5897,6 +5897,7 @@ static int be_probe(struct pci_dev *pdev, const struct pci_device_id *pdev_id)
>  unmap_bars:
>         be_unmap_pci_bars(adapter);
>  free_netdev:
> +       pci_disable_pcie_error_reporting(pdev);
>         free_netdev(netdev);
>  rel_reg:
>         pci_release_regions(pdev);
> --
> 2.30.2
>
Acked-by: Somnath Kotur <somnath.kotur@broadcom.com>

--00000000000058fe7e05c4eec46b
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
oZk87hf9I57ggDu+hSLe1hbPBgKly5q/r8XBHZkKDswEMqn7nOHCwm20q2jGMRVmR8qL4wlTZEVv
eKbQAkg/svNjuuAiD+ICbTd74UclYUh//bFNGT8h9SFHWQIDAQABo4IB2zCCAdcwDgYDVR0PAQH/
BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3VyZS5nbG9i
YWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEGCCsGAQUF
BzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAy
MDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xv
YmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6hjhodHRw
Oi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNybDAlBgNV
HREEHjAcgRpzb21uYXRoLmtvdHVyQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAf
BgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQU+mf+1dq8iI61FoBk3jqw
Jj8z7zMwDQYJKoZIhvcNAQELBQADggEBALjOl6MPEwswIci1hfGUMPy5zkNp7cgxhGE+xKR2wYff
RV3S826165wXomj0NkrWhJg3//CyuBx5RTfSuvac280tP+LoTYR6j0oMw1CZbAAnkmUJHToMObs5
7aK1M5vdbNpk5MbMiPGfHqMckjR4+PpgwtiiVke5HSSf0yDjRGZN9pC+VXntZByC8bAakbVbdtEI
RgXYbJHgFDMUrMDgm3LGPeZYcaQvasShlOOfME1IGePqI90RMcbhyT4kbetYwTgJGb9OyedCC9TU
rBFfmphPrlyu+GZ8t7XjYVacR9/jVOL038uTcYZBbU6XvjAIluKfs69qQgVO2rMQcGDYY/gxggJt
MIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYD
VQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgx8vKjD27wdrGWs
/5QwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIDbUi++mbobPMaQmBlAQybBOuKU5
2JNyWmEPeWNNIgRgMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MDYxNzA0MzczOFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQAlc5Ati0KMgz7vSbI2qDAegXZNMwBwmHwrr/8xLtr5LEKy
E5n1/T6JLnkA0ddvRT04GINnYvL2piLpi9OkaHzzdkO2Bx9hevjSVzbVTE54bIJDgop1+rYF0ZNw
y9a2aimyB2RA0glYX2zPzfLolRWl0TB5p/bi0ooGy36/9HWmCn3uqHaVZvk4huPErW39EFipH5r9
543Azwyn9B9/hfTtshELqrot5iYH/WK1zbLC1AZHBQB43JAxgWUBROdD9OfKFmOzYsSk5csmK79I
M0qRzjlyGYwwaYMK3h9hpPwSRm0lGakxHqOMOuJXcWi6Otfyb4xF4vkUSvwAZV5CyD8R
--00000000000058fe7e05c4eec46b--
