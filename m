Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35F8D14D0F1
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 20:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727881AbgA2TFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 14:05:04 -0500
Received: from mail-vk1-f196.google.com ([209.85.221.196]:43854 "EHLO
        mail-vk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727515AbgA2TFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 14:05:04 -0500
Received: by mail-vk1-f196.google.com with SMTP id m195so277546vkh.10
        for <netdev@vger.kernel.org>; Wed, 29 Jan 2020 11:05:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=c0E6qn6cOx6otH1ai5Xz66nLfQpfZ4Q8TrbUMyqcAB4=;
        b=jNLTqoiaBXIcSYrjmzcSt8XkRqb3ZFi4ZBsP50kw/+xtiPmZLgF0pL+bos3db3rUWg
         ZJiAVAuv4A6bFBaC+ERgMCknxSQOmAPle3MD+vc+P9eMFQVJinAgRi8wNOxBHF2sLR1l
         N05WWBBNUq2OSTcf65agFW8BdwigIwjdv0He0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=c0E6qn6cOx6otH1ai5Xz66nLfQpfZ4Q8TrbUMyqcAB4=;
        b=lH8GdeE4DmPJRh3HtSRjAWD0p46pzRb6EGK341/J3EIv+o1Gg5a6xCgQtbeqZABX+2
         a7bV5k10JUJDA9VeVgWRsaOa68O+FxPd+UA/WfGdAvO4puzwcNlR3AZBL3+yaBhMkbcj
         9pCcwrgc+gUrOJyPBFZOhE/zDpie+8asd+A6qYFomgT5IHbOF5J+RiQbWFroOpJpl/q9
         OLgQBOLAMqM/jwMvZBqoiq7otBq5zU/bHYkf36o1MYSvdc9MFW4HgqbxcC+98o+q9fhh
         s9aN2SvuAimDY98/l2o1MByI4QstUqJTWoRyiPL+AVJR1/lBmsOmw+E8FprpQmK/n93+
         ERqA==
X-Gm-Message-State: APjAAAW0JDOBgLBvquV/6YTv537jFV+cfaoXKWGrG25dqDuLInxGfDMF
        qZ4OMSTtreyq0kkUbAUK1q58MvlxnPS9w2eUyB1rug==
X-Google-Smtp-Source: APXvYqwmxEpTRhCoezcqP+pHH/okWobIgqbCaTeeoMZ/F49/RVs1TvVN04OXikpMB5UhlMcnz/wqxTT4edrhqkad/sQ=
X-Received: by 2002:a1f:8d0f:: with SMTP id p15mr400488vkd.100.1580324700760;
 Wed, 29 Jan 2020 11:05:00 -0800 (PST)
MIME-Version: 1.0
References: <20200128015848.226966-1-abhishekpandit@chromium.org>
 <20200127175842.RFC.v2.3.Icc7c35e1cabf10f8a383a009694987520f1d1b35@changeid> <B12B959B-7504-4FC9-B7B7-7EB139049684@holtmann.org>
In-Reply-To: <B12B959B-7504-4FC9-B7B7-7EB139049684@holtmann.org>
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Date:   Wed, 29 Jan 2020 11:04:48 -0800
Message-ID: <CANFp7mUHcP3cjLxrjsxsXA7bOd1wvST2xjXgM0==sxby=ha0Ww@mail.gmail.com>
Subject: Re: [RFC PATCH v2 3/4] Bluetooth: Update filters/whitelists for suspend
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Alain Michaud <alainm@chromium.org>,
        Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        chromeos-bluetooth-upstreaming@chromium.org,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcel,

On Wed, Jan 29, 2020 at 12:40 AM Marcel Holtmann <marcel@holtmann.org> wrot=
e:
>
> Hi Abhishek,
>
> > When suspending, update the event filter for BR/EDR devices and the
> > whitelist for LE devices. BR/EDR devices are added to the event filter
> > and will auto-connect if found during suspend. For LE, we update the
> > filter to remove everything that is not wakeable during suspend.
> > Finally, we disconnect all connected devices and wait for that to
> > complete before returning in the suspend notifier.
> >
> > An example suspend flow with 1 BR/EDR HID device, 1 BR/EDR audio device=
,
> > 1 LE HID device, 1 LE non-HID (where HIDs are wakeable):
> >
> > PM_PREPARE_SUSPEND:
> >  - Set event filter for BR/EDR HID device
> >  - Clear anything from LE whitelist that is not wakeable
> >  - Add (if not there) the LE HID device
> >  - Disconnect all devices
>
> is this really the right order? Why not disconnect all devices first. We =
are suspending after all, so lets disconnect first and then create the appr=
opriate accept filters.
>
> I have the feeling it would also make the overall logic a lot simpler sin=
ce it fits more into the current model that is used internally for a lot of=
 decision points (especially with LE).
>
> > PM_POST_SUSPEND:
> >  - Clear event filter
> >  - Restore LE whitelist (deleting anything not in le_pend_conn or
> >    le_pend_report and then adding from those lists)
> >
> > Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> > ---
> >
> > Changes in v2:
> > * Refactored filters and whitelist settings to its own patch
> > * Refactored update_white_list to have clearer edge cases
> > * Add connected devices to whitelist (previously missing corner case)
> >
> > include/net/bluetooth/hci.h      |  17 +-
> > include/net/bluetooth/hci_core.h |   5 +
> > net/bluetooth/hci_event.c        |  28 ++-
> > net/bluetooth/hci_request.c      | 308 +++++++++++++++++++++++++------
> > net/bluetooth/mgmt.c             |   8 +
> > 5 files changed, 298 insertions(+), 68 deletions(-)
> >
> > diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
> > index 6293bdd7d862..720d8e633f7e 100644
> > --- a/include/net/bluetooth/hci.h
> > +++ b/include/net/bluetooth/hci.h
> > @@ -932,10 +932,14 @@ struct hci_cp_sniff_subrate {
> > #define HCI_OP_RESET                  0x0c03
> >
> > #define HCI_OP_SET_EVENT_FLT          0x0c05
> > -struct hci_cp_set_event_flt {
> > -     __u8     flt_type;
> > -     __u8     cond_type;
> > -     __u8     condition[0];
> > +#define HCI_SET_EVENT_FLT_SIZE               9
> > +struct hci_cp_set_event_filter {
> > +     __u8            flt_type;
> > +     __u8            cond_type;
> > +     struct {
> > +             bdaddr_t bdaddr;
> > +             __u8 auto_accept;
> > +     } __packed      addr_conn_flt;
> > } __packed;
> >
> > /* Filter types */
> > @@ -949,8 +953,9 @@ struct hci_cp_set_event_flt {
> > #define HCI_CONN_SETUP_ALLOW_BDADDR   0x02
> >
> > /* CONN_SETUP Conditions */
> > -#define HCI_CONN_SETUP_AUTO_OFF      0x01
> > -#define HCI_CONN_SETUP_AUTO_ON       0x02
> > +#define HCI_CONN_SETUP_AUTO_OFF              0x01
> > +#define HCI_CONN_SETUP_AUTO_ON               0x02
> > +#define HCI_CONN_SETUP_AUTO_ON_WITH_RS       0x03
> >
> > #define HCI_OP_READ_STORED_LINK_KEY   0x0c0d
> > struct hci_cp_read_stored_link_key {
> > diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/h=
ci_core.h
> > index 74d703e46fb4..49eae4a802ac 100644
> > --- a/include/net/bluetooth/hci_core.h
> > +++ b/include/net/bluetooth/hci_core.h
> > @@ -91,6 +91,9 @@ struct discovery_state {
> > #define SUSPEND_NOTIFIER_TIMEOUT      msecs_to_jiffies(2000) /* 2 secon=
ds */
> >
> > enum suspend_tasks {
> > +     SUSPEND_LE_SET_SCAN_ENABLE,
> > +     SUSPEND_DISCONNECTING,
> > +
> >       SUSPEND_PREPARE_NOTIFIER,
> >       __SUSPEND_NUM_TASKS
> > };
> > @@ -406,6 +409,8 @@ struct hci_dev {
> >       struct work_struct      suspend_prepare;
> >       enum suspended_state    suspend_state_next;
> >       enum suspended_state    suspend_state;
> > +     int                     disconnect_counter;
> > +     bool                    freeze_filters;
> >
> >       wait_queue_head_t       suspend_wait_q;
> >       DECLARE_BITMAP(suspend_tasks, __SUSPEND_NUM_TASKS);
> > diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> > index 6ddc4a74a5e4..76d25b3f4c73 100644
> > --- a/net/bluetooth/hci_event.c
> > +++ b/net/bluetooth/hci_event.c
> > @@ -2474,6 +2474,7 @@ static void hci_inquiry_result_evt(struct hci_dev=
 *hdev, struct sk_buff *skb)
> > static void hci_conn_complete_evt(struct hci_dev *hdev, struct sk_buff =
*skb)
> > {
> >       struct hci_ev_conn_complete *ev =3D (void *) skb->data;
> > +     struct inquiry_entry *ie;
> >       struct hci_conn *conn;
> >
> >       BT_DBG("%s", hdev->name);
> > @@ -2482,14 +2483,29 @@ static void hci_conn_complete_evt(struct hci_de=
v *hdev, struct sk_buff *skb)
> >
> >       conn =3D hci_conn_hash_lookup_ba(hdev, ev->link_type, &ev->bdaddr=
);
> >       if (!conn) {
> > -             if (ev->link_type !=3D SCO_LINK)
> > -                     goto unlock;
> > +             /* Connection may not exist if auto-connected. Check the =
inquiry
> > +              * cache to see if we've already discovered this bdaddr b=
efore.
> > +              * Create a new connection if it was previously discovere=
d.
> > +              */
> > +             ie =3D hci_inquiry_cache_lookup(hdev, &ev->bdaddr);
> > +             if (ie) {
> > +                     conn =3D hci_conn_add(hdev, ev->link_type, &ev->b=
daddr,
> > +                                         HCI_ROLE_SLAVE);
> > +                     if (!conn) {
> > +                             bt_dev_err(hdev, "no memory for new conn"=
);
> > +                             goto unlock;
> > +                     }
> > +             } else {
> > +                     if (ev->link_type !=3D SCO_LINK)
> > +                             goto unlock;
>
> We are not going to get SCO_LINK auto-connected and thus we should really=
 have it done just for ACL links. I don=E2=80=99t have good proposal to str=
ucture this handling at the moment, but we need to clean this up a bit.

Ack, will look deeper into this.

>
> > -             conn =3D hci_conn_hash_lookup_ba(hdev, ESCO_LINK, &ev->bd=
addr);
> > -             if (!conn)
> > -                     goto unlock;
> > +                     conn =3D hci_conn_hash_lookup_ba(hdev, ESCO_LINK,
> > +                                                    &ev->bdaddr);
> > +                     if (!conn)
> > +                             goto unlock;
> >
> > -             conn->type =3D SCO_LINK;
> > +                     conn->type =3D SCO_LINK;
> > +             }
> >       }
> >
> >       if (!ev->status) {
> > diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
> > index 08908469c043..c930b9ff1cfd 100644
> > --- a/net/bluetooth/hci_request.c
> > +++ b/net/bluetooth/hci_request.c
> > @@ -34,6 +34,12 @@
> > #define HCI_REQ_PEND    1
> > #define HCI_REQ_CANCELED  2
> >
> > +#define LE_SCAN_FLAG_SUSPEND 0x1
> > +#define LE_SCAN_FLAG_ALLOW_RPA       0x2
> > +
> > +#define LE_SUSPEND_SCAN_WINDOW               0x0012
> > +#define LE_SUSPEND_SCAN_INTERVAL     0x0060
> > +
> > void hci_req_init(struct hci_request *req, struct hci_dev *hdev)
> > {
> >       skb_queue_head_init(&req->cmd_q);
> > @@ -654,6 +660,12 @@ void hci_req_add_le_scan_disable(struct hci_reques=
t *req)
> > {
> >       struct hci_dev *hdev =3D req->hdev;
> >
> > +     /* Early exit if we've frozen filters for suspend*/
>
> Please fix the coding style for comments. Extra space required between su=
spend and */
>
> I also have the feeling that we should split BR/EDR from LE support. I th=
ink we can merge the BR/EDR support quicker since it is a lot simpler. Espe=
cially when it stands on its own.

Ack. I kept them merged because I didn't want to change the request
completion function but I can separate them.

>
> > +     if (hdev->freeze_filters) {
> > +             BT_DBG("Filters are frozen for suspend");
> > +             return;
> > +     }
> > +
> >       if (use_ext_scan(hdev)) {
> >               struct hci_cp_le_set_ext_scan_enable cp;
> >
> > @@ -670,23 +682,67 @@ void hci_req_add_le_scan_disable(struct hci_reque=
st *req)
> >       }
> > }
> >
> > -static void add_to_white_list(struct hci_request *req,
> > -                           struct hci_conn_params *params)
> > +static void del_from_white_list(struct hci_request *req, bdaddr_t *bda=
ddr,
> > +                             u8 bdaddr_type)
> > +{
> > +     struct hci_cp_le_del_from_white_list cp;
> > +
> > +     cp.bdaddr_type =3D bdaddr_type;
> > +     bacpy(&cp.bdaddr, bdaddr);
> > +
> > +     BT_DBG("Remove %pMR (0x%x) from whitelist", &cp.bdaddr, cp.bdaddr=
_type);
> > +     hci_req_add(req, HCI_OP_LE_DEL_FROM_WHITE_LIST, sizeof(cp), &cp);
> > +}
> > +
> > +/* Adds connection to white list if needed. On error, returns -1 */
> > +static int add_to_white_list(struct hci_request *req,
> > +                          struct hci_conn_params *params, u8 *num_entr=
ies,
> > +                          u8 flags)
> > {
> >       struct hci_cp_le_add_to_white_list cp;
> > +     struct hci_dev *hdev =3D req->hdev;
> > +     bool allow_rpa =3D !!(flags & LE_SCAN_FLAG_ALLOW_RPA);
> > +     bool suspend =3D !!(flags & LE_SCAN_FLAG_SUSPEND);
> >
> > +     /* Already in white list */
> > +     if (hci_bdaddr_list_lookup(&hdev->le_white_list, &params->addr,
> > +                                params->addr_type))
> > +             return 0;
> > +
> > +     /* Select filter policy to accept all advertising */
> > +     if (*num_entries >=3D hdev->le_white_list_size)
> > +             return -1;
> > +
> > +     /* White list can not be used with RPAs */
> > +     if (!allow_rpa &&
> > +         hci_find_irk_by_addr(hdev, &params->addr, params->addr_type))=
 {
> > +             return -1;
> > +     }
> > +
> > +     /* During suspend, only wakeable devices can be in whitelist */
> > +     if (suspend && !hci_bdaddr_list_lookup(&hdev->wakeable, &params->=
addr,
> > +                                            params->addr_type))
> > +             return 0;
> > +
> > +     *num_entries +=3D 1;
> >       cp.bdaddr_type =3D params->addr_type;
> >       bacpy(&cp.bdaddr, &params->addr);
> >
> > +     BT_DBG("Add %pMR (0x%x) to whitelist", &cp.bdaddr, cp.bdaddr_type=
);
> >       hci_req_add(req, HCI_OP_LE_ADD_TO_WHITE_LIST, sizeof(cp), &cp);
> > +
> > +     return 0;
> > }
> >
> > -static u8 update_white_list(struct hci_request *req)
> > +static u8 update_white_list(struct hci_request *req, u8 flags)
> > {
> >       struct hci_dev *hdev =3D req->hdev;
> >       struct hci_conn_params *params;
> >       struct bdaddr_list *b;
> > -     uint8_t white_list_entries =3D 0;
> > +     u8 white_list_entries =3D 0;
> > +     bool allow_rpa =3D !!(flags & LE_SCAN_FLAG_ALLOW_RPA);
> > +     bool suspend =3D !!(flags & LE_SCAN_FLAG_SUSPEND);
> > +     bool wakeable, pend_conn, pend_report;
> >
> >       /* Go through the current white list programmed into the
> >        * controller one by one and check if that address is still
> > @@ -695,26 +751,42 @@ static u8 update_white_list(struct hci_request *r=
eq)
> >        * command to remove it from the controller.
> >        */
> >       list_for_each_entry(b, &hdev->le_white_list, list) {
> > -             /* If the device is neither in pend_le_conns nor
> > -              * pend_le_reports then remove it from the whitelist.
> > +             wakeable =3D !!hci_bdaddr_list_lookup(&hdev->wakeable, &b=
->bdaddr,
> > +                                                 b->bdaddr_type);
> > +             pend_conn =3D hci_pend_le_action_lookup(&hdev->pend_le_co=
nns,
> > +                                                   &b->bdaddr,
> > +                                                   b->bdaddr_type);
> > +             pend_report =3D hci_pend_le_action_lookup(&hdev->pend_le_=
reports,
> > +                                                     &b->bdaddr,
> > +                                                     b->bdaddr_type);
> > +
> > +             /* During suspend, we remove all non-wakeable devices
> > +              * and leave all others alone. Connected devices will be
> > +              * disconnected during suspend but may not be in the pend=
ing
> > +              * list yet.
> >                */
> > -             if (!hci_pend_le_action_lookup(&hdev->pend_le_conns,
> > -                                            &b->bdaddr, b->bdaddr_type=
) &&
> > -                 !hci_pend_le_action_lookup(&hdev->pend_le_reports,
> > -                                            &b->bdaddr, b->bdaddr_type=
)) {
> > -                     struct hci_cp_le_del_from_white_list cp;
> > -
> > -                     cp.bdaddr_type =3D b->bdaddr_type;
> > -                     bacpy(&cp.bdaddr, &b->bdaddr);
> > -
> > -                     hci_req_add(req, HCI_OP_LE_DEL_FROM_WHITE_LIST,
> > -                                 sizeof(cp), &cp);
> > -                     continue;
> > -             }
> > +             if (suspend) {
> > +                     if (!wakeable) {
> > +                             del_from_white_list(req, &b->bdaddr,
> > +                                                 b->bdaddr_type);
> > +                             continue;
> > +                     }
> > +             } else {
> > +                     /* If the device is not likely to connect or repo=
rt,
> > +                      * remove it from the whitelist.
> > +                      */
> > +                     if (!pend_conn && !pend_report) {
> > +                             del_from_white_list(req, &b->bdaddr,
> > +                                                 b->bdaddr_type);
> > +                             continue;
> > +                     }
> >
> > -             if (hci_find_irk_by_addr(hdev, &b->bdaddr, b->bdaddr_type=
)) {
> >                       /* White list can not be used with RPAs */
> > -                     return 0x00;
> > +                     if (!allow_rpa &&
> > +                         hci_find_irk_by_addr(hdev, &b->bdaddr,
> > +                                              b->bdaddr_type)) {
> > +                             return 0x00;
> > +                     }
> >               }
> >
> >               white_list_entries++;
> > @@ -731,47 +803,30 @@ static u8 update_white_list(struct hci_request *r=
eq)
> >        * white list.
> >        */
> >       list_for_each_entry(params, &hdev->pend_le_conns, action) {
> > -             if (hci_bdaddr_list_lookup(&hdev->le_white_list,
> > -                                        &params->addr, params->addr_ty=
pe))
> > -                     continue;
> > -
> > -             if (white_list_entries >=3D hdev->le_white_list_size) {
> > -                     /* Select filter policy to accept all advertising=
 */
> > +             if (add_to_white_list(req, params, &white_list_entries, f=
lags))
> >                       return 0x00;
> > -             }
> > -
> > -             if (hci_find_irk_by_addr(hdev, &params->addr,
> > -                                      params->addr_type)) {
> > -                     /* White list can not be used with RPAs */
> > -                     return 0x00;
> > -             }
> > -
> > -             white_list_entries++;
> > -             add_to_white_list(req, params);
> >       }
> >
> >       /* After adding all new pending connections, walk through
> >        * the list of pending reports and also add these to the
> > -      * white list if there is still space.
> > +      * white list if there is still space. Abort if space runs out.
> >        */
> >       list_for_each_entry(params, &hdev->pend_le_reports, action) {
> > -             if (hci_bdaddr_list_lookup(&hdev->le_white_list,
> > -                                        &params->addr, params->addr_ty=
pe))
> > -                     continue;
> > -
> > -             if (white_list_entries >=3D hdev->le_white_list_size) {
> > -                     /* Select filter policy to accept all advertising=
 */
> > +             if (add_to_white_list(req, params, &white_list_entries, f=
lags))
> >                       return 0x00;
> > -             }
> > +     }
> >
> > -             if (hci_find_irk_by_addr(hdev, &params->addr,
> > -                                      params->addr_type)) {
> > -                     /* White list can not be used with RPAs */
> > -                     return 0x00;
> > +     /* Currently connected devices will be missing from the white lis=
t and
> > +      * we need to insert them into the whitelist if they are wakeable=
. We
> > +      * can't insert later because we will have already returned from =
the
> > +      * suspend notifier and would cause a spurious wakeup.
> > +      */
> > +     if (suspend) {
> > +             list_for_each_entry(params, &hdev->le_conn_params, list) =
{
> > +                     if (add_to_white_list(req, params, &white_list_en=
tries,
> > +                                           flags))
> > +                             return 0x00;
> >               }
> > -
> > -             white_list_entries++;
> > -             add_to_white_list(req, params);
> >       }
>
> This goes to my point above. If we just disconnect everything, then the w=
hite list programming should be easily. Everything that is pending and have=
 been elected for wakeup + incoming connection will be added. And then we a=
re done. I don=E2=80=99t think much has to change except one extra check if=
 wakeup is allowed or not.
>
> >
> >       /* Select filter policy to use white list */
> > @@ -861,11 +916,26 @@ static void hci_req_start_scan(struct hci_request=
 *req, u8 type, u16 interval,
> >       }
> > }
> >
> > -void hci_req_add_le_passive_scan(struct hci_request *req)
> > +void __hci_req_add_le_passive_scan(struct hci_request *req, u8 flags)
> > {
> >       struct hci_dev *hdev =3D req->hdev;
> >       u8 own_addr_type;
> >       u8 filter_policy;
> > +     u8 window, interval;
> > +
> > +     /* We allow whitelisting even with RPAs in suspend. In the worst =
case,
> > +      * we won't be able to wake from devices that use the privacy1.2
> > +      * features. Additionally, once we support privacy1.2 and IRK
> > +      * offloading, we can update this to also check for those conditi=
ons.
> > +      */
> > +     if (flags & LE_SCAN_FLAG_SUSPEND)
> > +             flags |=3D LE_SCAN_FLAG_ALLOW_RPA;
> > +
> > +     /* Early exit if we've frozen filters for suspend */
> > +     if (hdev->freeze_filters) {
> > +             BT_DBG("Filters are frozen for suspend");
> > +             return;
> > +     }
> >
> >       /* Set require_privacy to false since no SCAN_REQ are send
> >        * during passive scanning. Not using an non-resolvable address
> > @@ -881,7 +951,8 @@ void hci_req_add_le_passive_scan(struct hci_request=
 *req)
> >        * happen before enabling scanning. The controller does
> >        * not allow white list modification while scanning.
> >        */
> > -     filter_policy =3D update_white_list(req);
> > +     BT_DBG("Updating white list with flags =3D %d", flags);
> > +     filter_policy =3D update_white_list(req, flags);
> >
> >       /* When the controller is using random resolvable addresses and
> >        * with that having LE privacy enabled, then controllers with
> > @@ -896,8 +967,22 @@ void hci_req_add_le_passive_scan(struct hci_reques=
t *req)
> >           (hdev->le_features[0] & HCI_LE_EXT_SCAN_POLICY))
> >               filter_policy |=3D 0x02;
> >
> > -     hci_req_start_scan(req, LE_SCAN_PASSIVE, hdev->le_scan_interval,
> > -                        hdev->le_scan_window, own_addr_type, filter_po=
licy);
> > +     if (flags & LE_SCAN_FLAG_SUSPEND) {
> > +             window =3D LE_SUSPEND_SCAN_WINDOW;
> > +             interval =3D LE_SUSPEND_SCAN_INTERVAL;
>
> I think we just want this done via some hdev->suspended variable or simil=
ar.

In support of setting a separate flag, it is easier to grep for when a
specific flag is being used and passed to a function than it is to
check when a variable is being set in a global context variable.

>
> > +     } else {
> > +             window =3D hdev->le_scan_window;
> > +             interval =3D hdev->le_scan_interval;
> > +     }
> > +
> > +     BT_DBG("LE passive scan with whitelist =3D %d", filter_policy);
> > +     hci_req_start_scan(req, LE_SCAN_PASSIVE, interval, window,
> > +                        own_addr_type, filter_policy);
> > +}
> > +
> > +void hci_req_add_le_passive_scan(struct hci_request *req)
> > +{
> > +     __hci_req_add_le_passive_scan(req, 0);
> > }
> >
> > static u8 get_adv_instance_scan_rsp_len(struct hci_dev *hdev, u8 instan=
ce)
> > @@ -918,6 +1003,76 @@ static u8 get_adv_instance_scan_rsp_len(struct hc=
i_dev *hdev, u8 instance)
> >       return adv_instance->scan_rsp_len;
> > }
> >
> > +static void hci_req_clear_event_filter(struct hci_request *req)
> > +{
> > +     struct hci_cp_set_event_filter f;
> > +
> > +     memset(&f, 0, sizeof(f));
> > +     f.flt_type =3D HCI_FLT_CLEAR_ALL;
> > +     hci_req_add(req, HCI_OP_SET_EVENT_FLT, 1, &f);
> > +
> > +     /* Update page scan state (since we may have modified it when set=
ting
> > +      * the event filter).
> > +      */
> > +     __hci_req_update_scan(req);
> > +}
> > +
> > +static void hci_req_set_event_filter(struct hci_request *req)
> > +{
> > +     struct bdaddr_list *b;
> > +     struct hci_cp_set_event_filter f;
> > +     struct hci_dev *hdev =3D req->hdev;
> > +     int filters_updated =3D 0;
> > +     u8 scan;
> > +
> > +     /* Always clear event filter when starting */
> > +     hci_req_clear_event_filter(req);
> > +
> > +     list_for_each_entry(b, &hdev->wakeable, list) {
> > +             if (b->bdaddr_type !=3D BDADDR_BREDR)
> > +                     continue;
> > +
> > +             memset(&f, 0, sizeof(f));
> > +             bacpy(&f.addr_conn_flt.bdaddr, &b->bdaddr);
> > +             f.flt_type =3D HCI_FLT_CONN_SETUP;
> > +             f.cond_type =3D HCI_CONN_SETUP_ALLOW_BDADDR;
> > +             f.addr_conn_flt.auto_accept =3D HCI_CONN_SETUP_AUTO_ON;
> > +
> > +             BT_DBG("Adding event filters for %pMR", &b->bdaddr);
> > +             hci_req_add(req, HCI_OP_SET_EVENT_FLT, sizeof(f), &f);
> > +
> > +             filters_updated++;
> > +     }
>
> If we would use the wakeable list just for BR/EDR then the filters_update=
d++ would become redundant and we could just check if the list is empty.
>
> > +
> > +     scan =3D filters_updated ? SCAN_PAGE : SCAN_DISABLED;
> > +     hci_req_add(req, HCI_OP_WRITE_SCAN_ENABLE, 1, &scan);
> > +}
> > +
> > +static void hci_req_enable_le_suspend_scan(struct hci_request *req,
> > +                                        u8 flags)
> > +{
> > +     /* Can't change params without disabling first */
> > +     hci_req_add_le_scan_disable(req);
> > +
> > +     /* Configure params and enable scanning */
> > +     __hci_req_add_le_passive_scan(req, flags);
> > +
> > +     /* Block suspend notifier on response */
> > +     set_bit(SUSPEND_LE_SET_SCAN_ENABLE, req->hdev->suspend_tasks);
> > +}
> > +
> > +static void le_suspend_req_complete(struct hci_dev *hdev, u8 status, u=
16 opcode)
> > +{
> > +     BT_DBG("Request complete opcode=3D0x%x, status=3D0x%x", opcode, s=
tatus);
> > +
> > +     /* Expecting LE Set scan to return */
> > +     if (opcode =3D=3D HCI_OP_LE_SET_SCAN_ENABLE &&
> > +         test_and_clear_bit(SUSPEND_LE_SET_SCAN_ENABLE,
> > +                            hdev->suspend_tasks)) {
> > +             wake_up(&hdev->suspend_wait_q);
> > +     }
> > +}
> > +
> > /* Call with hci_dev_lock */
> > void hci_req_prepare_suspend(struct hci_dev *hdev, enum suspended_state=
 next)
> > {
> > @@ -932,6 +1087,44 @@ void hci_req_prepare_suspend(struct hci_dev *hdev=
, enum suspended_state next)
> >
> >       hdev->suspend_state =3D next;
> >
> > +     hci_req_init(&req, hdev);
> > +     if (next =3D=3D BT_SUSPENDED) {
> > +             /* Enable event filter for existing devices */
> > +             hci_req_set_event_filter(&req);
> > +
> > +             /* Enable passive scan at lower duty cycle */
> > +             hci_req_enable_le_suspend_scan(&req, LE_SCAN_FLAG_SUSPEND=
);
> > +
> > +             hdev->freeze_filters =3D true;
> > +
> > +             /* Run commands before disconnecting */
> > +             hci_req_run(&req, le_suspend_req_complete);
> > +
> > +             hdev->disconnect_counter =3D 0;
> > +             /* Soft disconnect everything (power off)*/
> > +             list_for_each_entry(conn, &hdev->conn_hash.list, list) {
> > +                     hci_disconnect(conn, HCI_ERROR_REMOTE_POWER_OFF);
> > +                     hdev->disconnect_counter++;
> > +             }
> > +
> > +             if (hdev->disconnect_counter > 0) {
> > +                     BT_DBG("Had %d disconnects. Will wait on them",
> > +                            hdev->disconnect_counter);
> > +                     set_bit(SUSPEND_DISCONNECTING, hdev->suspend_task=
s);
> > +             }
> > +     } else {
> > +             hdev->freeze_filters =3D false;
> > +
> > +             hci_req_clear_event_filter(&req);
> > +
> > +             /* Reset passive/background scanning to normal */
> > +             hci_req_enable_le_suspend_scan(&req, 0);
> > +
> > +             hci_req_run(&req, le_suspend_req_complete);
> > +     }
> > +
> > +     hdev->suspend_state =3D next;
> > +
> > done:
> >       clear_bit(SUSPEND_PREPARE_NOTIFIER, hdev->suspend_tasks);
> >       wake_up(&hdev->suspend_wait_q);
> > @@ -2034,6 +2227,9 @@ void __hci_req_update_scan(struct hci_request *re=
q)
> >       if (mgmt_powering_down(hdev))
> >               return;
> >
> > +     if (hdev->freeze_filters)
> > +             return;
> > +
> >       if (hci_dev_test_flag(hdev, HCI_CONNECTABLE) ||
> >           disconnected_whitelist_entries(hdev))
> >               scan =3D SCAN_PAGE;
> > diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
> > index 58468dfa112f..269ce70e501c 100644
> > --- a/net/bluetooth/mgmt.c
> > +++ b/net/bluetooth/mgmt.c
> > @@ -7451,6 +7451,14 @@ void mgmt_device_disconnected(struct hci_dev *hd=
ev, bdaddr_t *bdaddr,
> >
> >       mgmt_event(MGMT_EV_DEVICE_DISCONNECTED, hdev, &ev, sizeof(ev), sk=
);
> >
> > +     if (hdev->disconnect_counter > 0) {
> > +             hdev->disconnect_counter--;
> > +             if (hdev->disconnect_counter <=3D 0) {
> > +                     clear_bit(SUSPEND_DISCONNECTING, hdev->suspend_ta=
sks);
> > +                     wake_up(&hdev->suspend_wait_q);
> > +             }
> > +     }
> > +
>
> I think this disconnect_counter is a bit racy. I would rather check that =
our connection hash is empty.
>
> In addition, I have the feeling we better disable LE scanning BR/EDR page=
 scan first. So that we clearly do not have any artifacts of accidental inc=
oming connections.
>
> The first step when going to suspend should clean the house
>
>         1) Set a flag that all BR/EDR and LE connection attempts are reje=
cted
>         2) Disable BR/EDR page scan
>         3) Disable LE advertising
>         2) Disable LE scanning / BR/EDR inquiry
>         4) Disconnect all
>
> Now we have a clean house and we now prepare for wakeup triggers
>
>         1) Clear flag and allow incoming connection
>         2) Set BR/EDR event filter and enable page scan if needed
>         3) Set LE whitelist and enable scanning if needed
>
> When we wake up, then we also just need to reset the filters
>
>         1) Clear BR/EDR event filter and enable page scan if needed
>         2) Update LE white and enable scanning if needed
>         3) Restore LE scanning / BR/EDR inquiry
>

I think this is reasonable so I will try to implement it. Might take
me a couple of days (traveling out of country) so expect the next
patch series early next week.

> Regards
>
> Marcel
>

Cheers
Abhishek
