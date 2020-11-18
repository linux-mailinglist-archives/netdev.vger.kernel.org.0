Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6266D2B7AA4
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 10:51:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbgKRJtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 04:49:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbgKRJtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 04:49:17 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8E48C0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 01:49:16 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id j205so2042668lfj.6
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 01:49:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XZeL/azb40DrxcTIApv38T8h5hlp9ujVC/80OsUQitc=;
        b=XoOr8ZqIajrx9tSrMHf/JB+3Gcf6KtXtlGXqZheEIz+cya2sI5DszLZLMARdjqqRa/
         g87m6ItpVW6qQe9ctoU+0DLodLi+zsE9u5tuDVUBVKccEH3bf5Pv2ZhFZTxAEheGeA0F
         UeZTMxYDB78J35IZyRK6TyxNe40dHCqvIqmSU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XZeL/azb40DrxcTIApv38T8h5hlp9ujVC/80OsUQitc=;
        b=tZxBRNGQUuGRhEiUA8MiEmX2FuhLFKOGMTCPA0MxCh4eOv5w0CpN1gEb213PzLJXdC
         yUT0JPlo/uMgpLQsbM3BSb84vgi/rdXacaKeA1Gma9jnFwKIpRMQXkFu+B9sfHeFx5QS
         2eDvofNXb21Tlvs3HkqbidW92YPJ6HcKW3K23YG6kgsWPDnFKHFrbE92d823utlJNiqb
         SNoomK8SxUdlXj9vQuGrP+a+XFplhzWO4Cw0GuVtLvuQR1OeH7+rQREf6V776N6WNTx7
         w9hCZkPrgASz5l5qb5j1uQ2xUnaFiOHKBOlPDTpwJY9xRjSYjYvHxYsQ0OQfuUCjv08j
         Rw5w==
X-Gm-Message-State: AOAM531CnrJ/KJ1jfM457BOMHi4o4ClPNfflgFCqm5myUQrssEWwIT/a
        WC3RQenGofnvB/bup2bI+KrarzE0gDEdiKnyrl+Jwg==
X-Google-Smtp-Source: ABdhPJwY93dlu6o7UefgUQsdRn3aiRzZkXM3Kro5dhYSxTIWhhyHQK4G60vBtE6+P2xyfnmrl2VfDzMSdHrSzsVRU/8=
X-Received: by 2002:a19:483:: with SMTP id 125mr3561162lfe.203.1605692955013;
 Wed, 18 Nov 2020 01:49:15 -0800 (PST)
MIME-Version: 1.0
References: <20201117200820.854115-1-jacob.e.keller@intel.com> <20201117200820.854115-3-jacob.e.keller@intel.com>
In-Reply-To: <20201117200820.854115-3-jacob.e.keller@intel.com>
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date:   Wed, 18 Nov 2020 15:19:03 +0530
Message-ID: <CAACQVJravqbRwUK0H2Me0Qrz-0NGmB4Y3Xiezwtb3_rx9Bv+Kw@mail.gmail.com>
Subject: Re: [net-next v3 2/2] devlink: move flash end and begin to core devlink
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Shannon Nelson <snelson@pensando.io>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Bin Luo <luobin9@huawei.com>, Jakub Kicinksi <kuba@kernel.org>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000003b238605b45e868b"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000003b238605b45e868b
Content-Type: text/plain; charset="UTF-8"

On Wed, Nov 18, 2020 at 1:41 AM Jacob Keller <jacob.e.keller@intel.com> wrote:
>
> When performing a flash update via devlink, device drivers may inform
> user space of status updates via
> devlink_flash_update_(begin|end|timeout|status)_notify functions.
>
> It is expected that drivers do not send any status notifications unless
> they send a begin and end message. If a driver sends a status
> notification without sending the appropriate end notification upon
> finishing (regardless of success or failure), the current implementation
> of the devlink userspace program can get stuck endlessly waiting for the
> end notification that will never come.
>
> The current ice driver implementation may send such a status message
> without the appropriate end notification in rare cases.
>
> Fixing the ice driver is relatively simple: we just need to send the
> begin_notify at the start of the function and always send an end_notify
> no matter how the function exits.
>
> Rather than assuming driver authors will always get this right in the
> future, lets just fix the API so that it is not possible to get wrong.
> Make devlink_flash_update_begin_notify and
> devlink_flash_update_end_notify static, and call them in devlink.c core
> code. Always send the begin_notify just before calling the driver's
> flash_update routine. Always send the end_notify just after the routine
> returns regardless of success or failure.
>
> Doing this makes the status notification easier to use from the driver,
> as it no longer needs to worry about catching failures and cleaning up
> by calling devlink_flash_update_end_notify. It is now no longer possible
> to do the wrong thing in this regard. We also save a couple of lines of
> code in each driver.
>
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> Cc: Jiri Pirko <jiri@nvidia.com>
> Cc: Michael Chan <michael.chan@broadcom.com>
> Cc: Shannon Nelson <snelson@pensando.io>
> Cc: Saeed Mahameed <saeedm@nvidia.com>
> Cc: Boris Pismenny <borisp@nvidia.com>
> Cc: Bin Luo <luobin9@huawei.com>
> Cc: Jakub Kicinksi <kuba@kernel.org>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c |  2 --
>  drivers/net/ethernet/intel/ice/ice_devlink.c      |  5 +----
>  drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c   |  3 ---
>  drivers/net/ethernet/pensando/ionic/ionic_fw.c    |  2 --
>  drivers/net/netdevsim/dev.c                       |  2 --
>  include/net/devlink.h                             |  2 --
>  net/core/devlink.c                                | 10 ++++++----
>  7 files changed, 7 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
> index 4ebae8a236fd..6b7b69ed62db 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
> @@ -30,14 +30,12 @@ bnxt_dl_flash_update(struct devlink *dl,
>                 return -EPERM;
>         }
>
> -       devlink_flash_update_begin_notify(dl);
>         devlink_flash_update_status_notify(dl, "Preparing to flash", NULL, 0, 0);
>         rc = bnxt_flash_package_from_fw_obj(bp->dev, params->fw, 0);
>         if (!rc)
>                 devlink_flash_update_status_notify(dl, "Flashing done", NULL, 0, 0);
>         else
>                 devlink_flash_update_status_notify(dl, "Flashing failed", NULL, 0, 0);
> -       devlink_flash_update_end_notify(dl);
>         return rc;
>  }
>
> diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
> index 0036d3e7df0b..29d6192b15f3 100644
> --- a/drivers/net/ethernet/intel/ice/ice_devlink.c
> +++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
> @@ -275,12 +275,9 @@ ice_devlink_flash_update(struct devlink *devlink,
>         if (err)
>                 return err;
>
> -       devlink_flash_update_begin_notify(devlink);
>         devlink_flash_update_status_notify(devlink, "Preparing to flash", NULL, 0, 0);
> -       err = ice_flash_pldm_image(pf, params->fw, preservation, extack);
> -       devlink_flash_update_end_notify(devlink);
>
> -       return err;
> +       return ice_flash_pldm_image(pf, params->fw, preservation, extack);
>  }
>
>  static const struct devlink_ops ice_devlink_ops = {
> diff --git a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
> index bcd166911d44..46245e0b2462 100644
> --- a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
> +++ b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
> @@ -368,7 +368,6 @@ int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
>         }
>
>         mlxfw_info(mlxfw_dev, "Initialize firmware flash process\n");
> -       devlink_flash_update_begin_notify(mlxfw_dev->devlink);
>         mlxfw_status_notify(mlxfw_dev, "Initializing firmware flash process",
>                             NULL, 0, 0);
>         err = mlxfw_dev->ops->fsm_lock(mlxfw_dev, &fwhandle);
> @@ -417,7 +416,6 @@ int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
>         mlxfw_info(mlxfw_dev, "Firmware flash done\n");
>         mlxfw_status_notify(mlxfw_dev, "Firmware flash done", NULL, 0, 0);
>         mlxfw_mfa2_file_fini(mfa2_file);
> -       devlink_flash_update_end_notify(mlxfw_dev->devlink);
>         return 0;
>
>  err_state_wait_activate_to_locked:
> @@ -429,7 +427,6 @@ int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
>         mlxfw_dev->ops->fsm_release(mlxfw_dev, fwhandle);
>  err_fsm_lock:
>         mlxfw_mfa2_file_fini(mfa2_file);
> -       devlink_flash_update_end_notify(mlxfw_dev->devlink);
>         return err;
>  }
>  EXPORT_SYMBOL(mlxfw_firmware_flash);
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_fw.c b/drivers/net/ethernet/pensando/ionic/ionic_fw.c
> index fd2ce134f66c..4be7e932b7eb 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_fw.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_fw.c
> @@ -105,7 +105,6 @@ int ionic_firmware_update(struct ionic_lif *lif, const struct firmware *fw,
>         u8 fw_slot;
>
>         dl = priv_to_devlink(ionic);
> -       devlink_flash_update_begin_notify(dl);
>         devlink_flash_update_status_notify(dl, "Preparing to flash", NULL, 0, 0);
>
>         buf_sz = sizeof(idev->dev_cmd_regs->data);
> @@ -191,6 +190,5 @@ int ionic_firmware_update(struct ionic_lif *lif, const struct firmware *fw,
>                 devlink_flash_update_status_notify(dl, "Flash failed", NULL, 0, 0);
>         else
>                 devlink_flash_update_status_notify(dl, "Flash done", NULL, 0, 0);
> -       devlink_flash_update_end_notify(dl);
>         return err;
>  }
> diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
> index 49cc1fea9e02..5731d8b6566b 100644
> --- a/drivers/net/netdevsim/dev.c
> +++ b/drivers/net/netdevsim/dev.c
> @@ -764,7 +764,6 @@ static int nsim_dev_flash_update(struct devlink *devlink,
>                 return -EOPNOTSUPP;
>
>         if (nsim_dev->fw_update_status) {
> -               devlink_flash_update_begin_notify(devlink);
>                 devlink_flash_update_status_notify(devlink,
>                                                    "Preparing to flash",
>                                                    params->component, 0, 0);
> @@ -788,7 +787,6 @@ static int nsim_dev_flash_update(struct devlink *devlink,
>                                                     params->component, 81);
>                 devlink_flash_update_status_notify(devlink, "Flashing done",
>                                                    params->component, 0, 0);
> -               devlink_flash_update_end_notify(devlink);
>         }
>
>         return 0;
> diff --git a/include/net/devlink.h b/include/net/devlink.h
> index d1d125a33322..457c537d0ef2 100644
> --- a/include/net/devlink.h
> +++ b/include/net/devlink.h
> @@ -1577,8 +1577,6 @@ void devlink_remote_reload_actions_performed(struct devlink *devlink,
>                                              enum devlink_reload_limit limit,
>                                              u32 actions_performed);
>
> -void devlink_flash_update_begin_notify(struct devlink *devlink);
> -void devlink_flash_update_end_notify(struct devlink *devlink);
>  void devlink_flash_update_status_notify(struct devlink *devlink,
>                                         const char *status_msg,
>                                         const char *component,
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index b0121d79ac75..bf160d9b1106 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -3370,7 +3370,7 @@ static void __devlink_flash_update_notify(struct devlink *devlink,
>         nlmsg_free(msg);
>  }
>
> -void devlink_flash_update_begin_notify(struct devlink *devlink)
> +static void devlink_flash_update_begin_notify(struct devlink *devlink)
>  {
>         struct devlink_flash_notify params = { 0 };
>
> @@ -3378,9 +3378,8 @@ void devlink_flash_update_begin_notify(struct devlink *devlink)
>                                       DEVLINK_CMD_FLASH_UPDATE,
>                                       &params);
>  }
> -EXPORT_SYMBOL_GPL(devlink_flash_update_begin_notify);
>
> -void devlink_flash_update_end_notify(struct devlink *devlink)
> +static void devlink_flash_update_end_notify(struct devlink *devlink)
>  {
>         struct devlink_flash_notify params = { 0 };
>
> @@ -3388,7 +3387,6 @@ void devlink_flash_update_end_notify(struct devlink *devlink)
>                                       DEVLINK_CMD_FLASH_UPDATE_END,
>                                       &params);
>  }
> -EXPORT_SYMBOL_GPL(devlink_flash_update_end_notify);
>
>  void devlink_flash_update_status_notify(struct devlink *devlink,
>                                         const char *status_msg,
> @@ -3475,7 +3473,9 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
>                 return ret;
>         }
>
> +       devlink_flash_update_begin_notify(devlink);
>         ret = devlink->ops->flash_update(devlink, &params, info->extack);
> +       devlink_flash_update_end_notify(devlink);
>
>         release_firmware(params.fw);
>
> @@ -10242,7 +10242,9 @@ int devlink_compat_flash_update(struct net_device *dev, const char *file_name)
>                 goto out;
>
>         mutex_lock(&devlink->lock);
> +       devlink_flash_update_begin_notify(devlink);
>         ret = devlink->ops->flash_update(devlink, &params, NULL);
> +       devlink_flash_update_end_notify(devlink);
>         mutex_unlock(&devlink->lock);
>
>         release_firmware(params.fw);
> --
> 2.29.0
>
Acked-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

--0000000000003b238605b45e868b
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQUgYJKoZIhvcNAQcCoIIQQzCCED8CAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg2nMIIE6DCCA9CgAwIBAgIOSBtqCRO9gCTKXSLwFPMwDQYJKoZIhvcNAQELBQAwTDEgMB4GA1UE
CxMXR2xvYmFsU2lnbiBSb290IENBIC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNVBAMT
Ckdsb2JhbFNpZ24wHhcNMTYwNjE1MDAwMDAwWhcNMjQwNjE1MDAwMDAwWjBdMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTEzMDEGA1UEAxMqR2xvYmFsU2lnbiBQZXJzb25h
bFNpZ24gMiBDQSAtIFNIQTI1NiAtIEczMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
tpZok2X9LAHsYqMNVL+Ly6RDkaKar7GD8rVtb9nw6tzPFnvXGeOEA4X5xh9wjx9sScVpGR5wkTg1
fgJIXTlrGESmaqXIdPRd9YQ+Yx9xRIIIPu3Jp/bpbiZBKYDJSbr/2Xago7sb9nnfSyjTSnucUcIP
ZVChn6hKneVGBI2DT9yyyD3PmCEJmEzA8Y96qT83JmVH2GaPSSbCw0C+Zj1s/zqtKUbwE5zh8uuZ
p4vC019QbaIOb8cGlzgvTqGORwK0gwDYpOO6QQdg5d03WvIHwTunnJdoLrfvqUg2vOlpqJmqR+nH
9lHS+bEstsVJtZieU1Pa+3LzfA/4cT7XA/pnwwIDAQABo4IBtTCCAbEwDgYDVR0PAQH/BAQDAgEG
MGoGA1UdJQRjMGEGCCsGAQUFBwMCBggrBgEFBQcDBAYIKwYBBQUHAwkGCisGAQQBgjcUAgIGCisG
AQQBgjcKAwQGCSsGAQQBgjcVBgYKKwYBBAGCNwoDDAYIKwYBBQUHAwcGCCsGAQUFBwMRMBIGA1Ud
EwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYEFGlygmIxZ5VEhXeRgMQENkmdewthMB8GA1UdIwQYMBaA
FI/wS3+oLkUkrk1Q+mOai97i3Ru8MD4GCCsGAQUFBwEBBDIwMDAuBggrBgEFBQcwAYYiaHR0cDov
L29jc3AyLmdsb2JhbHNpZ24uY29tL3Jvb3RyMzA2BgNVHR8ELzAtMCugKaAnhiVodHRwOi8vY3Js
Lmdsb2JhbHNpZ24uY29tL3Jvb3QtcjMuY3JsMGcGA1UdIARgMF4wCwYJKwYBBAGgMgEoMAwGCisG
AQQBoDIBKAowQQYJKwYBBAGgMgFfMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2JhbHNp
Z24uY29tL3JlcG9zaXRvcnkvMA0GCSqGSIb3DQEBCwUAA4IBAQConc0yzHxn4gtQ16VccKNm4iXv
6rS2UzBuhxI3XDPiwihW45O9RZXzWNgVcUzz5IKJFL7+pcxHvesGVII+5r++9eqI9XnEKCILjHr2
DgvjKq5Jmg6bwifybLYbVUoBthnhaFB0WLwSRRhPrt5eGxMw51UmNICi/hSKBKsHhGFSEaJQALZy
4HL0EWduE6ILYAjX6BSXRDtHFeUPddb46f5Hf5rzITGLsn9BIpoOVrgS878O4JnfUWQi29yBfn75
HajifFvPC+uqn+rcVnvrpLgsLOYG/64kWX/FRH8+mhVe+mcSX3xsUpcxK9q9vLTVtroU/yJUmEC4
OcH5dQsbHBqjMIIDXzCCAkegAwIBAgILBAAAAAABIVhTCKIwDQYJKoZIhvcNAQELBQAwTDEgMB4G
A1UECxMXR2xvYmFsU2lnbiBSb290IENBIC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNV
BAMTCkdsb2JhbFNpZ24wHhcNMDkwMzE4MTAwMDAwWhcNMjkwMzE4MTAwMDAwWjBMMSAwHgYDVQQL
ExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UEAxMK
R2xvYmFsU2lnbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMwldpB5BngiFvXAg7aE
yiie/QV2EcWtiHL8RgJDx7KKnQRfJMsuS+FggkbhUqsMgUdwbN1k0ev1LKMPgj0MK66X17YUhhB5
uzsTgHeMCOFJ0mpiLx9e+pZo34knlTifBtc+ycsmWQ1z3rDI6SYOgxXG71uL0gRgykmmKPZpO/bL
yCiR5Z2KYVc3rHQU3HTgOu5yLy6c+9C7v/U9AOEGM+iCK65TpjoWc4zdQQ4gOsC0p6Hpsk+QLjJg
6VfLuQSSaGjlOCZgdbKfd/+RFO+uIEn8rUAVSNECMWEZXriX7613t2Saer9fwRPvm2L7DWzgVGkW
qQPabumDk3F2xmmFghcCAwEAAaNCMEAwDgYDVR0PAQH/BAQDAgEGMA8GA1UdEwEB/wQFMAMBAf8w
HQYDVR0OBBYEFI/wS3+oLkUkrk1Q+mOai97i3Ru8MA0GCSqGSIb3DQEBCwUAA4IBAQBLQNvAUKr+
yAzv95ZURUm7lgAJQayzE4aGKAczymvmdLm6AC2upArT9fHxD4q/c2dKg8dEe3jgr25sbwMpjjM5
RcOO5LlXbKr8EpbsU8Yt5CRsuZRj+9xTaGdWPoO4zzUhw8lo/s7awlOqzJCK6fBdRoyV3XpYKBov
Hd7NADdBj+1EbddTKJd+82cEHhXXipa0095MJ6RMG3NzdvQXmcIfeg7jLQitChws/zyrVQ4PkX42
68NXSb7hLi18YIvDQVETI53O9zJrlAGomecsMx86OyXShkDOOyyGeMlhLxS67ttVb9+E7gUJTb0o
2HLO02JQZR7rkpeDMdmztcpHWD9fMIIFVDCCBDygAwIBAgIMVmL467BsZ5dftNvMMA0GCSqGSIb3
DQEBCwUAMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTMwMQYDVQQD
EypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMwHhcNMjAwOTIxMTQy
NjU5WhcNMjIwOTIyMTQyNjU5WjCBmDELMAkGA1UEBhMCSU4xEjAQBgNVBAgTCUthcm5hdGFrYTES
MBAGA1UEBxMJQmFuZ2Fsb3JlMRYwFAYDVQQKEw1Ccm9hZGNvbSBJbmMuMRkwFwYDVQQDExBWYXN1
bmRoYXJhIFZvbGFtMS4wLAYJKoZIhvcNAQkBFh92YXN1bmRoYXJhLXYudm9sYW1AYnJvYWRjb20u
Y29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzQOtGQP5jOVYcVenYlTW4APZxzea
KLYz2bEjA7ce7ZlEoTJMMcp5NUdhMM21QCjPX1at8YE0RN1GOkik1SLwatkXruMItAA76Ghb46ML
IexJIhpysb5yLAL2wc+O0Xn9SetRooZc2CcD8/QV7lWMO6Jk2qfQ2ElqSWSWNw6rkeGXr7rQO6Bl
ULF5hqHbMF2qrqEWXW6A1JRFyPPu8gcAApUZKSq1v3qQPCMdyqcEBcIJn+MqE6Y8c78BCGkdVkmB
YS3R0dCZgl93IjbqtxySfyXCYBVcbmNI7TXYwPKDp3rYDuXJN+UPU+LuUTcffMyOyxGH45mhNXx5
RnSV48nP5wIDAQABo4IB1jCCAdIwDgYDVR0PAQH/BAQDAgWgMIGeBggrBgEFBQcBAQSBkTCBjjBN
BggrBgEFBQcwAoZBaHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NwZXJzb25h
bHNpZ24yc2hhMmczb2NzcC5jcnQwPQYIKwYBBQUHMAGGMWh0dHA6Ly9vY3NwMi5nbG9iYWxzaWdu
LmNvbS9nc3BlcnNvbmFsc2lnbjJzaGEyZzMwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYI
KwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQC
MAAwRAYDVR0fBD0wOzA5oDegNYYzaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc3BlcnNvbmFs
c2lnbjJzaGEyZzMuY3JsMCoGA1UdEQQjMCGBH3Zhc3VuZGhhcmEtdi52b2xhbUBicm9hZGNvbS5j
b20wEwYDVR0lBAwwCgYIKwYBBQUHAwQwHwYDVR0jBBgwFoAUaXKCYjFnlUSFd5GAxAQ2SZ17C2Ew
HQYDVR0OBBYEFKBXZ7bBA/b6lD9vCs1cnu0EUStlMA0GCSqGSIb3DQEBCwUAA4IBAQCUtbsWJbT8
mRvubq/HDaw7J1CrT0eVmhcStWb5oowqIv1vvivRBoNWBjCv8ME5o4mlhqb0f2uB1EqIL1B3oC4M
wslo5mPAA3SLSuE0k13VBajU3pBwidjPpuFZTXcmuZoRWTYp1iLFQHMoPF6ngcxlAzymFSxRhrDD
SqTlHafZ5cHnPvs2Vi1YYknDHNkg9Zu8jTqkIH35RfqBohg0aA37+n/4DivO4AkFT0uf/GAgmE3M
9TB6C6XSpcJwqMFie4QajeEVIuP7Iig2m95mEulo5aRerZDiITfACxDeZLEXlvVwaC/8E7MAnf0a
N9w2B4rts1llOp2FaxkZiIJC+xnGMYICbzCCAmsCAQEwbTBdMQswCQYDVQQGEwJCRTEZMBcGA1UE
ChMQR2xvYmFsU2lnbiBudi1zYTEzMDEGA1UEAxMqR2xvYmFsU2lnbiBQZXJzb25hbFNpZ24gMiBD
QSAtIFNIQTI1NiAtIEczAgxWYvjrsGxnl1+028wwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcN
AQkEMSIEIDt1bAowkUoaLPHud2uO6GzT7a3JNHNi9YeAERxUPrCGMBgGCSqGSIb3DQEJAzELBgkq
hkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIwMTExODA5NDkxNVowaQYJKoZIhvcNAQkPMVwwWjAL
BglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG
9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQB6/5SbUJcB
AvbCSkOpMlTOf0e/c7dxeI23SeBWU37NE7/xQ05UFOeIeRuykuwiF+E6wHn6K+RsgFSqitdrKc4u
yrfLTqxs+tq/nqcov5mgFHuPqkMd7rot24DlzHmRIxAmbGfF/ZFyVjVhRaeIu+DqM1O4kHu5X8yr
CIp5Qb9YzuGmclXvo5XkcQ4tSHIxtQG1MO5nDhpuzPhhbjlwAVnvtb1p26u4y4+ze79P2nTT8Bfj
zKyzTpd/rHC20l4dplys158Bu/riiknyU8v0pcl8R54K80dlFvU93qMEiwzY2i2SZvFRZ9lskji3
6n8LVnZvAQ8/RDRN0xGO6qKOG4E/
--0000000000003b238605b45e868b--
