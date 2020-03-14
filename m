Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0891858C0
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 03:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbgCOCXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 22:23:00 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:34001 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727469AbgCOCXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Mar 2020 22:23:00 -0400
Received: by mail-lj1-f193.google.com with SMTP id s13so14785374ljm.1;
        Sat, 14 Mar 2020 19:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=cc:subject:to:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+ZyqDkOF3uWWxVDIECGMJtE168zkXbxMgJTb6gnPSGI=;
        b=gUxOegdFDOTBDgWyZrf6ugdjgn7IAsexEdEx0Q1nYttVa9a3wV3c40gmawss+oN/tE
         DWXS+xMAcW3numKqykXq7XYiVb0E42W9P1Qp7FpHSJ5LbgRsBCqqUK4cQphD4kB0aDvQ
         PRtJP/ter6fSR0ldKEwRHlS404qeA+KOMOxmOeELrcF2csqX1RLcLIK/X8J2JggWE3ge
         HFYZuVy28dFxgPVJ1/014+ChXzVE8sOrsyK2yBFvecI9wEvKi50g0AE5QX3HsFaxpWtf
         eKkhVtJdXgEcArl68MGTCerpsXTmxJjEpatb+mlGxOQW/294YauVsfDAWjeHjsQf0ZGg
         czow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:cc:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+ZyqDkOF3uWWxVDIECGMJtE168zkXbxMgJTb6gnPSGI=;
        b=OSV7hICeZz27VHVy5LKqsA26Me5ciApp20YZ6zdZVwIjPjGmgBS5zphbG0qBvbbBHK
         +eVKQKInsyMsXJITXj2NCRMZfLjhR/8DZ9UAkcMrLstyh2wo0LJ0A3oX9ftEopZraZPV
         MyEhMKyDUTXEaHtY6UEUGd8uCW4fWrfuiZVdQQ7k/0IggsqbCr1eQJDC9rdEZk1Scg8f
         AEsxfylRZNLhhjqtuJHMdAYiEhIfPwHFuDFx2LyMxMskb6CbNlGYV4JdQKCHbtxggYEz
         /sqXHNgN2kPjYJ3nDnrluH80idcImQ3DQXkp4MyCOPZm4DJsabGv4qC3ZVgw/vuKjruB
         aQlA==
X-Gm-Message-State: ANhLgQ34NE0kNW4WgXwkT4MBk6qyrBMh8d+Cz20dNl03nZkxXGqMLZ2z
        x+vPQNiQPdFGyefrHTpdkeydbcwsN2Q=
X-Google-Smtp-Source: ADFU+vvZCDegguLj8vLsgJ44NEmZgLAGVYr+4JeSWWkjH6ko7oHZAxDmkufT2nNGCx2K1M02gM2NOA==
X-Received: by 2002:a5d:4a8c:: with SMTP id o12mr26717839wrq.10.1584223340528;
        Sat, 14 Mar 2020 15:02:20 -0700 (PDT)
Received: from ?IPv6:2001:a61:2482:101:3351:6160:8173:cc31? ([2001:a61:2482:101:3351:6160:8173:cc31])
        by smtp.gmail.com with ESMTPSA id p10sm85897598wrx.81.2020.03.14.15.02.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Mar 2020 15:02:20 -0700 (PDT)
Cc:     mtk.manpages@gmail.com, Jorgen Hansen <jhansen@vmware.com>,
        netdev@vger.kernel.org, linux-man@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Dexuan Cui <decui@microsoft.com>
Subject: Re: [PATCH v4] vsock.7: add VMADDR_CID_LOCAL description
To:     Stefano Garzarella <sgarzare@redhat.com>
References: <20200218155435.172860-1-sgarzare@redhat.com>
From:   "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Message-ID: <b3289245-ba42-24d4-b96c-267d09b2e37a@gmail.com>
Date:   Sat, 14 Mar 2020 23:02:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200218155435.172860-1-sgarzare@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Stefano,

On 2/18/20 4:54 PM, Stefano Garzarella wrote:
> Linux 5.6 added the new well-known VMADDR_CID_LOCAL for
> local communication.
> 
> This patch explains how to use it and remove the legacy
> VMADDR_CID_RESERVED no longer available.
> 
> Reviewed-by: Jorgen Hansen <jhansen@vmware.com>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
> v4:
>     * removed "The" in the "Local communication" section [Stefan]
> v3:
>     * rephrased "Previous versions" part [Jorgen]
> v2:
>     * rephrased "Local communication" description [Stefan]
>     * added a mention of previous versions that supported
>       loopback only in the guest [Stefan]

Thanks. Patch applied.

Cheers,

Michael


> ---
>  man7/vsock.7 | 18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/man7/vsock.7 b/man7/vsock.7
> index c5ffcf07d..fa2c6e17e 100644
> --- a/man7/vsock.7
> +++ b/man7/vsock.7
> @@ -127,8 +127,8 @@ There are several special addresses:
>  means any address for binding;
>  .B VMADDR_CID_HYPERVISOR
>  (0) is reserved for services built into the hypervisor;
> -.B VMADDR_CID_RESERVED
> -(1) must not be used;
> +.B VMADDR_CID_LOCAL
> +(1) is the well-known address for local communication (loopback);
>  .B VMADDR_CID_HOST
>  (2)
>  is the well-known address of the host.
> @@ -164,6 +164,15 @@ Consider using
>  .B VMADDR_CID_ANY
>  when binding instead of getting the local CID with
>  .BR IOCTL_VM_SOCKETS_GET_LOCAL_CID .
> +.SS Local communication
> +.B VMADDR_CID_LOCAL
> +(1) directs packets to the same host that generated them. This is useful
> +for testing applications on a single host and for debugging.
> +.PP
> +The local CID obtained with
> +.BR IOCTL_VM_SOCKETS_GET_LOCAL_CID
> +can be used for the same purpose, but it is preferable to use
> +.B VMADDR_CID_LOCAL .
>  .SH ERRORS
>  .TP
>  .B EACCES
> @@ -222,6 +231,11 @@ are valid.
>  Support for VMware (VMCI) has been available since Linux 3.9.
>  KVM (virtio) is supported since Linux 4.8.
>  Hyper-V is supported since Linux 4.14.
> +.PP
> +VMADDR_CID_LOCAL is supported since Linux 5.6.
> +Local communication in the guest and on the host is available since Linux 5.6.
> +Previous versions only supported local communication within a guest
> +(not on the host), and only with some transports (VMCI and virtio).
>  .SH SEE ALSO
>  .BR bind (2),
>  .BR connect (2),
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
