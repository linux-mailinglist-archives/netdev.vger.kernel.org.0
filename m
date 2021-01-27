Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09E87305C76
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 14:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238185AbhA0NGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 08:06:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237809AbhA0NE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 08:04:26 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBDE6C06174A;
        Wed, 27 Jan 2021 05:03:36 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id y5so1644128ilg.4;
        Wed, 27 Jan 2021 05:03:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xVu03WE8iCLZyPea99AkLIpyuQWUU66C3MJ9CSfzX6w=;
        b=t0qdm7CrxynN1hj01CUNzWDwPjeQ5Ix58BPDqy8I4W0PkDlM6QLT6zYibzYlkHlc0f
         qFkIqGSJFT/N9kqoCXHtCtjZ5Q3vZK5zePT+S0fA5zQSBwFHUhlG+DjxnL+R71GAVguy
         b6YWYxxzWHMUzPY67ERrCHfwdqbPrwyrdQ13V1P42wrhaD/09f2HCCiFVbnLEqmbH5AK
         dVDvIyZhRBQhNC+2CaEb79YA22KUx4i2D2vYbHBGauEH867SQ5466tJcpvs5GU3J7mio
         XcbSffpDZ8VfNnckSrzQxVKNm0MW5WthFgzJFgDz0RJkw33DYQsf7OkPlGorWtJ4Y4H7
         Cs2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xVu03WE8iCLZyPea99AkLIpyuQWUU66C3MJ9CSfzX6w=;
        b=lMG2CZJ7A4PssevRpE/+9fp1zGy4fCAW61xAt8XyOF76hDN5dL4sjc68nlDAwIHQsQ
         XOQ/NgM6xf5gtxHpyXk5FSZkvYkViGzRqOePLBwFX73zskb6FO4L96wKoYVLvIPkgs6/
         KTnSMWKuAkydg8zvAlydtHvFdwEipAF/PS0T2D6CdMVROGOLnvNd1ZGzhU19Vcv4PCvd
         xiDw/DM+pN58qnXdGpig8IWya3vpBnPKRBK0pYAClO5IgL+GI0nEmPDBfGrBC+2zKdIB
         CHRlRTLyxSfUkKz/O1l4qFiLkbYUO/ClSm0v2VvSOfDkf/poPyd65lzXprab+eTYqVtB
         tpWw==
X-Gm-Message-State: AOAM533eU+6y5r81sXqD6Be8Fohfb5v2wYQcqNxLM2t6wfXSo36nHYJ+
        phqScvkZR3CoBxDbqSGGsrs+ZKMTS+ePH1m0R6z8olhk
X-Google-Smtp-Source: ABdhPJxjZDYjvU9+Ya60s4BF+eB8eLjolcnWD52f5r7Etkgkh9L9hXhbk28Qm//OufpChIVrS8GJPA7gYZAvnDD+k6I=
X-Received: by 2002:a92:5e04:: with SMTP id s4mr8508203ilb.100.1611752616224;
 Wed, 27 Jan 2021 05:03:36 -0800 (PST)
MIME-Version: 1.0
References: <20210123092425.11434-1-bongsu.jeon@samsung.com>
 <20210123092425.11434-2-bongsu.jeon@samsung.com> <20210126174238.16d9691a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210126174238.16d9691a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
Date:   Wed, 27 Jan 2021 22:03:25 +0900
Message-ID: <CACwDmQDPeEWPrbLh_k3s_tLwBKfmBSB4cvZooonG-qhGGd-50A@mail.gmail.com>
Subject: Re: [PATCH net-next v3 1/2] nfc: Add a virtual nci device driver
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     shuah@kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        netdev@vger.kernel.org, linux-nfc@lists.01.org,
        linux-kselftest@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 10:42 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sat, 23 Jan 2021 18:24:24 +0900 Bongsu Jeon wrote:
> > From: Bongsu Jeon <bongsu.jeon@samsung.com>
> >
> > NCI virtual device simulates a NCI device to the user. It can be used to
> > validate the NCI module and applications. This driver supports
> > communication between the virtual NCI device and NCI module.
> >
> > Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
>
> > +static bool virtual_ncidev_check_enabled(void)
> > +{
> > +     bool ret = true;
> > +
> > +     mutex_lock(&nci_mutex);
> > +     if (state != virtual_ncidev_enabled)
> > +             ret = false;
> > +     mutex_unlock(&nci_mutex);
> > +
> > +     return ret;
>
>
> This can be simplified like:
>
>         bool ret;
>
>         mutex_lock()
>         ret = state == virtual_ncidev_enabled;
>         mutex_unlock()
>
>         return ret;
>
>
> > +}
> > +
> > +static int virtual_nci_open(struct nci_dev *ndev)
> > +{
> > +     return 0;
> > +}
> > +
> > +static int virtual_nci_close(struct nci_dev *ndev)
> > +{
> > +     mutex_lock(&nci_mutex);
> > +     if (send_buff)
> > +             kfree_skb(send_buff);
>
> kfree_skb() handles NULL, no need for the if, you can always call
> kfree_skb() here
>

I see, I will remove this.

> > +     send_buff = NULL;
> > +     mutex_unlock(&nci_mutex);
> > +
> > +     return 0;
> > +}
> > +
> > +static int virtual_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
> > +{
> > +     if (virtual_ncidev_check_enabled() == false)
> > +             return 0;
>
> Shouldn't you check this _under_ the lock below?
>
> Otherwise there is a small window between check and use of send_buff
>

In virtual_ncidev_check_enabled function, mutex is used.
I think that virtual_ncidev_check_enabled function isn't necessary
after refactoring.
So I'll remove it.

> > +     mutex_lock(&nci_mutex);
> > +     if (send_buff) {
> > +             mutex_unlock(&nci_mutex);
> > +             return -1;
> > +     }
> > +     send_buff = skb_copy(skb, GFP_KERNEL);
> > +     mutex_unlock(&nci_mutex);
> > +
> > +     return 0;
> > +}
> > +
> > +static struct nci_ops virtual_nci_ops = {
> > +     .open = virtual_nci_open,
> > +     .close = virtual_nci_close,
> > +     .send = virtual_nci_send
> > +};
> > +
> > +static ssize_t virtual_ncidev_read(struct file *file, char __user *buf,
> > +                                size_t count, loff_t *ppos)
> > +{
> > +     size_t actual_len;
> > +
> > +     mutex_lock(&nci_mutex);
> > +     if (!send_buff) {
> > +             mutex_unlock(&nci_mutex);
> > +             return 0;
> > +     }
> > +
> > +     actual_len = min_t(size_t, count, send_buff->len);
> > +
> > +     if (copy_to_user(buf, send_buff->data, actual_len)) {
> > +             mutex_unlock(&nci_mutex);
> > +             return -EFAULT;
> > +     }
> > +
> > +     skb_pull(send_buff, actual_len);
> > +     if (send_buff->len == 0) {
> > +             consume_skb(send_buff);
> > +             send_buff = NULL;
> > +     }
> > +     mutex_unlock(&nci_mutex);
> > +
> > +     return actual_len;
> > +}
> > +
> > +static ssize_t virtual_ncidev_write(struct file *file,
> > +                                 const char __user *buf,
> > +                                 size_t count, loff_t *ppos)
> > +{
> > +     struct sk_buff *skb;
> > +
> > +     skb = alloc_skb(count, GFP_KERNEL);
> > +     if (!skb)
> > +             return -ENOMEM;
> > +
> > +     if (copy_from_user(skb_put(skb, count), buf, count)) {
> > +             kfree_skb(skb);
> > +             return -EFAULT;
> > +     }
> > +
> > +     nci_recv_frame(ndev, skb);
> > +     return count;
> > +}
> > +
> > +static int virtual_ncidev_open(struct inode *inode, struct file *file)
> > +{
> > +     int ret = 0;
> > +
> > +     mutex_lock(&nci_mutex);
> > +     if (state != virtual_ncidev_disabled) {
> > +             mutex_unlock(&nci_mutex);
> > +             return -EBUSY;
> > +     }
> > +
> > +     ndev = nci_allocate_device(&virtual_nci_ops, VIRTUAL_NFC_PROTOCOLS,
> > +                                0, 0);
> > +     if (!ndev) {
> > +             mutex_unlock(&nci_mutex);
> > +             return -ENOMEM;
> > +     }
> > +
> > +     ret = nci_register_device(ndev);
> > +     if (ret < 0) {
> > +             nci_free_device(ndev);
> > +             mutex_unlock(&nci_mutex);
> > +             return ret;
> > +     }
> > +     state = virtual_ncidev_enabled;
> > +     mutex_unlock(&nci_mutex);
> > +
> > +     return 0;
> > +}
> > +
> > +static int virtual_ncidev_close(struct inode *inode, struct file *file)
> > +{
> > +     mutex_lock(&nci_mutex);
> > +
> > +     if (state == virtual_ncidev_enabled) {
> > +             state = virtual_ncidev_disabling;
> > +             mutex_unlock(&nci_mutex);
> > +
> > +             nci_unregister_device(ndev);
> > +             nci_free_device(ndev);
> > +
> > +             mutex_lock(&nci_mutex);
> > +     }
> > +
> > +     state = virtual_ncidev_disabled;
> > +     mutex_unlock(&nci_mutex);
> > +
> > +     return 0;
> > +}
> > +
> > +static long virtual_ncidev_ioctl(struct file *flip, unsigned int cmd,
> > +                              unsigned long arg)
> > +{
> > +     if (cmd == IOCTL_GET_NCIDEV_IDX) {
> > +             struct nfc_dev *nfc_dev = ndev->nfc_dev;
> > +             void __user *p = (void __user *)arg;
> > +
> > +             if (copy_to_user(p, &nfc_dev->idx, sizeof(nfc_dev->idx)))
> > +                     return -EFAULT;
> > +     } else {
> > +             return -ENOTTY;
> > +     }
> > +
> > +     return 0;
>
> Please flip the condition and return early. I think I suggested this
> already:

Sorry, I didn't misunderstand it.
I will change it.

>
> {
>         struct nfc_dev *nfc_dev = ndev->nfc_dev;
>         void __user *p = (void __user *)arg;
>
>         if (cmd != IOCTL_GET_NCIDEV_IDX)
>                 return -ENOTTY;
>
>         if (copy_to_user(p, &nfc_dev->idx, sizeof(nfc_dev->idx)))
>                 return -EFAULT;
>
>         return 0;

Thank you for your review.
