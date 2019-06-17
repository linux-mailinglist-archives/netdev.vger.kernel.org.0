Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8CB548FC6
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 21:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbfFQTpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 15:45:21 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38294 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725839AbfFQTpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 15:45:21 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5HJiuju028138;
        Mon, 17 Jun 2019 12:44:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=DCDZiiJBXyogsDvftmIyc7HkZ87L+yT3tG7EDslIPkk=;
 b=g1VKuS6YwMzw44e/DHlqqbC85Swotvy26qdAiPIiclgmkwNyETFctBInGaF5Y2E8DE8j
 T69C5Mjh/VaXUUesVnyIoBPI5ZISrLvfjSts3mVucIiS6/AMtLU5Ll9WOymJTMHgSWjT
 fBXq/u7m01+TR+Am5dx+Me3ouOX52D5ZVV8= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0b-00082601.pphosted.com with ESMTP id 2t6bn01agw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 17 Jun 2019 12:44:55 -0700
Received: from prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 17 Jun 2019 12:44:02 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 17 Jun 2019 12:44:02 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 17 Jun 2019 12:44:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DCDZiiJBXyogsDvftmIyc7HkZ87L+yT3tG7EDslIPkk=;
 b=O2fY8/DOAXKVOb7quvp2Gp0kZfobaLoQzP1/O3FJDk6XJCyaaA9teCq9X9WxpbIUn4lieqLhEIymaeLOmHOm+iZxlWtn1TWQlAeskdm07WgsmaNcstJJlJn41Hcbm0sdVBsOojGFN1qreES2RhO6fisi2EXMGCaSre9ri9daRhM=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1119.namprd15.prod.outlook.com (10.175.8.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Mon, 17 Jun 2019 19:43:27 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d%6]) with mapi id 15.20.1987.014; Mon, 17 Jun 2019
 19:43:27 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 07/11] libbpf: allow specifying map
 definitions using BTF
Thread-Topic: [PATCH v2 bpf-next 07/11] libbpf: allow specifying map
 definitions using BTF
Thread-Index: AQHVJULVgivvSU7/qUGU2NyeH2GMt6agP1YA
Date:   Mon, 17 Jun 2019 19:43:27 +0000
Message-ID: <6AE03EFF-1EF8-486B-BD85-11B440D1C589@fb.com>
References: <20190617192700.2313445-1-andriin@fb.com>
 <20190617192700.2313445-8-andriin@fb.com>
In-Reply-To: <20190617192700.2313445-8-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::3:da81]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 42573a60-cce0-4710-2b10-08d6f35c11b3
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1119;
x-ms-traffictypediagnostic: MWHPR15MB1119:
x-microsoft-antispam-prvs: <MWHPR15MB1119753F360FEC7330919CA2B3EB0@MWHPR15MB1119.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0071BFA85B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(396003)(39860400002)(366004)(376002)(189003)(199004)(5660300002)(53946003)(30864003)(66446008)(186003)(66556008)(64756008)(14444005)(66476007)(99286004)(66946007)(73956011)(229853002)(46003)(76116006)(6506007)(6486002)(8676002)(86362001)(81166006)(256004)(81156014)(305945005)(6116002)(6436002)(53546011)(8936002)(102836004)(76176011)(4326008)(7736002)(25786009)(68736007)(14454004)(6512007)(486006)(50226002)(36756003)(478600001)(6862004)(37006003)(33656002)(53936002)(11346002)(6246003)(2906002)(2616005)(57306001)(6636002)(316002)(71200400001)(71190400001)(476003)(446003)(54906003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1119;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: KIlgUkV+HZrjD7GMlrtuVTrv4SrTwiESB9E6V+UzD7wATA9OFv0ZXP9c1M2Z4IgiOnv6Ds/+sQwlxFlDHh056TGo5822kTrd3Sz2mQgYE+T8gXLdvNPCpHJo652duNYl+HEHgSRJoLcuOWeMvPFjgqT/8avpzTsM9SL1ok/ZG0DeL5JoOXJMf0F/hSJdP2wLtnE+O4RcWm1hLtJGC9a74KbXwQKElu6IDAuEp3lFLvCL0j3eTg7skpOqFky2Enb//JNTIn56gGbfVLIVBfeRh9V0nXIF4HCmba2mldNyeFWeReRV4/IeGcrJ44dzscEWYZ1lUsAMofjf1xaa8XmqLYm2+M7rPd4ZCKU1hcplo1Cy7fB1KOaNW+p0g9EG9jImfZ2tHqThLhuaiNQ8XW6tvf9tvBqNPpPFYneIEBFgRY4=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D76AECD59C717B47AD21D1C5D65A2EFE@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 42573a60-cce0-4710-2b10-08d6f35c11b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2019 19:43:27.7528
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1119
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-17_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906170172
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 17, 2019, at 12:26 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>=20
> This patch adds support for a new way to define BPF maps. It relies on
> BTF to describe mandatory and optional attributes of a map, as well as
> captures type information of key and value naturally. This eliminates
> the need for BPF_ANNOTATE_KV_PAIR hack and ensures key/value sizes are
> always in sync with the key/value type.
>=20
> Relying on BTF, this approach allows for both forward and backward
> compatibility w.r.t. extending supported map definition features. By
> default, any unrecognized attributes are treated as an error, but it's
> possible relax this using MAPS_RELAX_COMPAT flag. New attributes, added
> in the future will need to be optional.
>=20
> The outline of the new map definition (short, BTF-defined maps) is as fol=
lows:
> 1. All the maps should be defined in .maps ELF section. It's possible to
>   have both "legacy" map definitions in `maps` sections and BTF-defined
>   maps in .maps sections. Everything will still work transparently.
> 2. The map declaration and initialization is done through
>   a global/static variable of a struct type with few mandatory and
>   extra optional fields:
>   - type field is mandatory and specified type of BPF map;
>   - key/value fields are mandatory and capture key/value type/size inform=
ation;
>   - max_entries attribute is optional; if max_entries is not specified or
>     initialized, it has to be provided in runtime through libbpf API
>     before loading bpf_object;
>   - map_flags is optional and if not defined, will be assumed to be 0.
> 3. Key/value fields should be **a pointer** to a type describing
>   key/value. The pointee type is assumed (and will be recorded as such
>   and used for size determination) to be a type describing key/value of
>   the map. This is done to save excessive amounts of space allocated in
>   corresponding ELF sections for key/value of big size.
> 4. As some maps disallow having BTF type ID associated with key/value,
>   it's possible to specify key/value size explicitly without
>   associating BTF type ID with it. Use key_size and value_size fields
>   to do that (see example below).
>=20
> Here's an example of simple ARRAY map defintion:
>=20
> struct my_value { int x, y, z; };
>=20
> struct {
> 	int type;
> 	int max_entries;
> 	int *key;
> 	struct my_value *value;
> } btf_map SEC(".maps") =3D {
> 	.type =3D BPF_MAP_TYPE_ARRAY,
> 	.max_entries =3D 16,
> };
>=20
> This will define BPF ARRAY map 'btf_map' with 16 elements. The key will
> be of type int and thus key size will be 4 bytes. The value is struct
> my_value of size 12 bytes. This map can be used from C code exactly the
> same as with existing maps defined through struct bpf_map_def.
>=20
> Here's an example of STACKMAP definition (which currently disallows BTF t=
ype
> IDs for key/value):
>=20
> struct {
> 	__u32 type;
> 	__u32 max_entries;
> 	__u32 map_flags;
> 	__u32 key_size;
> 	__u32 value_size;
> } stackmap SEC(".maps") =3D {
> 	.type =3D BPF_MAP_TYPE_STACK_TRACE,
> 	.max_entries =3D 128,
> 	.map_flags =3D BPF_F_STACK_BUILD_ID,
> 	.key_size =3D sizeof(__u32),
> 	.value_size =3D PERF_MAX_STACK_DEPTH * sizeof(struct bpf_stack_build_id)=
,
> };
>=20
> This approach is naturally extended to support map-in-map, by making a va=
lue
> field to be another struct that describes inner map. This feature is not
> implemented yet. It's also possible to incrementally add features like pi=
nning
> with full backwards and forward compatibility. Support for static
> initialization of BPF_MAP_TYPE_PROG_ARRAY using pointers to BPF programs
> is also on the roadmap.
>=20
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>


> ---
> tools/lib/bpf/btf.h    |   1 +
> tools/lib/bpf/libbpf.c | 353 +++++++++++++++++++++++++++++++++++++++--
> 2 files changed, 345 insertions(+), 9 deletions(-)
>=20
> diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
> index ba4ffa831aa4..88a52ae56fc6 100644
> --- a/tools/lib/bpf/btf.h
> +++ b/tools/lib/bpf/btf.h
> @@ -17,6 +17,7 @@ extern "C" {
>=20
> #define BTF_ELF_SEC ".BTF"
> #define BTF_EXT_ELF_SEC ".BTF.ext"
> +#define MAPS_ELF_SEC ".maps"
>=20
> struct btf;
> struct btf_ext;
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index da942ab2f06a..585e3a2f1eb4 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -262,6 +262,7 @@ struct bpf_object {
> 		} *reloc;
> 		int nr_reloc;
> 		int maps_shndx;
> +		int btf_maps_shndx;
> 		int text_shndx;
> 		int data_shndx;
> 		int rodata_shndx;
> @@ -514,6 +515,7 @@ static struct bpf_object *bpf_object__new(const char =
*path,
> 	obj->efile.obj_buf =3D obj_buf;
> 	obj->efile.obj_buf_sz =3D obj_buf_sz;
> 	obj->efile.maps_shndx =3D -1;
> +	obj->efile.btf_maps_shndx =3D -1;
> 	obj->efile.data_shndx =3D -1;
> 	obj->efile.rodata_shndx =3D -1;
> 	obj->efile.bss_shndx =3D -1;
> @@ -1007,6 +1009,312 @@ static int bpf_object__init_user_maps(struct bpf_=
object *obj, bool strict)
> 	return 0;
> }
>=20
> +static const struct btf_type *skip_mods_and_typedefs(const struct btf *b=
tf,
> +						     __u32 id)
> +{
> +	const struct btf_type *t =3D btf__type_by_id(btf, id);
> +
> +	while (true) {
> +		switch (BTF_INFO_KIND(t->info)) {
> +		case BTF_KIND_VOLATILE:
> +		case BTF_KIND_CONST:
> +		case BTF_KIND_RESTRICT:
> +		case BTF_KIND_TYPEDEF:
> +			t =3D btf__type_by_id(btf, t->type);
> +			break;
> +		default:
> +			return t;
> +		}
> +	}
> +}
> +
> +static bool get_map_field_int(const char *map_name,
> +			      const struct btf *btf,
> +			      const struct btf_type *def,
> +			      const struct btf_member *m,
> +			      const void *data, __u32 *res) {
> +	const struct btf_type *t =3D skip_mods_and_typedefs(btf, m->type);
> +	const char *name =3D btf__name_by_offset(btf, m->name_off);
> +	__u32 int_info =3D *(const __u32 *)(const void *)(t + 1);
> +
> +	if (BTF_INFO_KIND(t->info) !=3D BTF_KIND_INT) {
> +		pr_warning("map '%s': attr '%s': expected INT, got %u.\n",
> +			   map_name, name, BTF_INFO_KIND(t->info));
> +		return false;
> +	}
> +	if (t->size !=3D 4 || BTF_INT_BITS(int_info) !=3D 32 ||
> +	    BTF_INT_OFFSET(int_info)) {
> +		pr_warning("map '%s': attr '%s': expected 32-bit non-bitfield integer,=
 "
> +			   "got %u-byte (%d-bit) one with bit offset %d.\n",
> +			   map_name, name, t->size, BTF_INT_BITS(int_info),
> +			   BTF_INT_OFFSET(int_info));
> +		return false;
> +	}
> +	if (BTF_INFO_KFLAG(def->info) && BTF_MEMBER_BITFIELD_SIZE(m->offset)) {
> +		pr_warning("map '%s': attr '%s': bitfield is not supported.\n",
> +			   map_name, name);
> +		return false;
> +	}
> +	if (m->offset % 32) {
> +		pr_warning("map '%s': attr '%s': unaligned fields are not supported.\n=
",
> +			   map_name, name);
> +		return false;
> +	}
> +
> +	*res =3D *(const __u32 *)(data + m->offset / 8);
> +	return true;
> +}
> +
> +static int bpf_object__init_user_btf_map(struct bpf_object *obj,
> +					 const struct btf_type *sec,
> +					 int var_idx, int sec_idx,
> +					 const Elf_Data *data, bool strict)
> +{
> +	const struct btf_type *var, *def, *t;
> +	const struct btf_var_secinfo *vi;
> +	const struct btf_var *var_extra;
> +	const struct btf_member *m;
> +	const void *def_data;
> +	const char *map_name;
> +	struct bpf_map *map;
> +	int vlen, i;
> +
> +	vi =3D (const struct btf_var_secinfo *)(const void *)(sec + 1) + var_id=
x;
> +	var =3D btf__type_by_id(obj->btf, vi->type);
> +	var_extra =3D (const void *)(var + 1);
> +	map_name =3D btf__name_by_offset(obj->btf, var->name_off);
> +	vlen =3D BTF_INFO_VLEN(var->info);
> +
> +	if (map_name =3D=3D NULL || map_name[0] =3D=3D '\0') {
> +		pr_warning("map #%d: empty name.\n", var_idx);
> +		return -EINVAL;
> +	}
> +	if ((__u64)vi->offset + vi->size > data->d_size) {
> +		pr_warning("map '%s' BTF data is corrupted.\n", map_name);
> +		return -EINVAL;
> +	}
> +	if (BTF_INFO_KIND(var->info) !=3D BTF_KIND_VAR) {
> +		pr_warning("map '%s': unexpected var kind %u.\n",
> +			   map_name, BTF_INFO_KIND(var->info));
> +		return -EINVAL;
> +	}
> +	if (var_extra->linkage !=3D BTF_VAR_GLOBAL_ALLOCATED &&
> +	    var_extra->linkage !=3D BTF_VAR_STATIC) {
> +		pr_warning("map '%s': unsupported var linkage %u.\n",
> +			   map_name, var_extra->linkage);
> +		return -EOPNOTSUPP;
> +	}
> +
> +	def =3D skip_mods_and_typedefs(obj->btf, var->type);
> +	if (BTF_INFO_KIND(def->info) !=3D BTF_KIND_STRUCT) {
> +		pr_warning("map '%s': unexpected def kind %u.\n",
> +			   map_name, BTF_INFO_KIND(var->info));
> +		return -EINVAL;
> +	}
> +	if (def->size > vi->size) {
> +		pr_warning("map '%s': invalid def size.\n", map_name);
> +		return -EINVAL;
> +	}
> +
> +	map =3D bpf_object__add_map(obj);
> +	if (IS_ERR(map))
> +		return PTR_ERR(map);
> +	map->name =3D strdup(map_name);
> +	if (!map->name) {
> +		pr_warning("map '%s': failed to alloc map name.\n", map_name);
> +		return -ENOMEM;
> +	}
> +	map->libbpf_type =3D LIBBPF_MAP_UNSPEC;
> +	map->def.type =3D BPF_MAP_TYPE_UNSPEC;
> +	map->sec_idx =3D sec_idx;
> +	map->sec_offset =3D vi->offset;
> +	pr_debug("map '%s': at sec_idx %d, offset %zu.\n",
> +		 map_name, map->sec_idx, map->sec_offset);
> +
> +	def_data =3D data->d_buf + vi->offset;
> +	vlen =3D BTF_INFO_VLEN(def->info);
> +	m =3D (const void *)(def + 1);
> +	for (i =3D 0; i < vlen; i++, m++) {
> +		const char *name =3D btf__name_by_offset(obj->btf, m->name_off);
> +
> +		if (!name) {
> +			pr_warning("map '%s': invalid field #%d.\n",
> +				   map_name, i);
> +			return -EINVAL;
> +		}
> +		if (strcmp(name, "type") =3D=3D 0) {
> +			if (!get_map_field_int(map_name, obj->btf, def, m,
> +					       def_data, &map->def.type))
> +				return -EINVAL;
> +			pr_debug("map '%s': found type =3D %u.\n",
> +				 map_name, map->def.type);
> +		} else if (strcmp(name, "max_entries") =3D=3D 0) {
> +			if (!get_map_field_int(map_name, obj->btf, def, m,
> +					       def_data, &map->def.max_entries))
> +				return -EINVAL;
> +			pr_debug("map '%s': found max_entries =3D %u.\n",
> +				 map_name, map->def.max_entries);
> +		} else if (strcmp(name, "map_flags") =3D=3D 0) {
> +			if (!get_map_field_int(map_name, obj->btf, def, m,
> +					       def_data, &map->def.map_flags))
> +				return -EINVAL;
> +			pr_debug("map '%s': found map_flags =3D %u.\n",
> +				 map_name, map->def.map_flags);
> +		} else if (strcmp(name, "key_size") =3D=3D 0) {
> +			__u32 sz;
> +
> +			if (!get_map_field_int(map_name, obj->btf, def, m,
> +					       def_data, &sz))
> +				return -EINVAL;
> +			pr_debug("map '%s': found key_size =3D %u.\n",
> +				 map_name, sz);
> +			if (map->def.key_size && map->def.key_size !=3D sz) {
> +				pr_warning("map '%s': conflictling key size %u !=3D %u.\n",
> +					   map_name, map->def.key_size, sz);
> +				return -EINVAL;
> +			}
> +			map->def.key_size =3D sz;
> +		} else if (strcmp(name, "key") =3D=3D 0) {
> +			__s64 sz;
> +
> +			t =3D btf__type_by_id(obj->btf, m->type);
> +			if (!t) {
> +				pr_warning("map '%s': key type [%d] not found.\n",
> +					   map_name, m->type);
> +				return -EINVAL;
> +			}
> +			if (BTF_INFO_KIND(t->info) !=3D BTF_KIND_PTR) {
> +				pr_warning("map '%s': key spec is not PTR: %u.\n",
> +					   map_name, BTF_INFO_KIND(t->info));
> +				return -EINVAL;
> +			}
> +			sz =3D btf__resolve_size(obj->btf, t->type);
> +			if (sz < 0) {
> +				pr_warning("map '%s': can't determine key size for type [%u]: %lld.\=
n",
> +					   map_name, t->type, sz);
> +				return sz;
> +			}
> +			pr_debug("map '%s': found key [%u], sz =3D %lld.\n",
> +				 map_name, t->type, sz);
> +			if (map->def.key_size && map->def.key_size !=3D sz) {
> +				pr_warning("map '%s': conflictling key size %u !=3D %lld.\n",
> +					   map_name, map->def.key_size, sz);
> +				return -EINVAL;
> +			}
> +			map->def.key_size =3D sz;
> +			map->btf_key_type_id =3D t->type;
> +		} else if (strcmp(name, "value_size") =3D=3D 0) {
> +			__u32 sz;
> +
> +			if (!get_map_field_int(map_name, obj->btf, def, m,
> +					       def_data, &sz))
> +				return -EINVAL;
> +			pr_debug("map '%s': found value_size =3D %u.\n",
> +				 map_name, sz);
> +			if (map->def.value_size && map->def.value_size !=3D sz) {
> +				pr_warning("map '%s': conflictling value size %u !=3D %u.\n",
> +					   map_name, map->def.value_size, sz);
> +				return -EINVAL;
> +			}
> +			map->def.value_size =3D sz;
> +		} else if (strcmp(name, "value") =3D=3D 0) {
> +			__s64 sz;
> +
> +			t =3D btf__type_by_id(obj->btf, m->type);
> +			if (!t) {
> +				pr_warning("map '%s': value type [%d] not found.\n",
> +					   map_name, m->type);
> +				return -EINVAL;
> +			}
> +			if (BTF_INFO_KIND(t->info) !=3D BTF_KIND_PTR) {
> +				pr_warning("map '%s': value spec is not PTR: %u.\n",
> +					   map_name, BTF_INFO_KIND(t->info));
> +				return -EINVAL;
> +			}
> +			sz =3D btf__resolve_size(obj->btf, t->type);
> +			if (sz < 0) {
> +				pr_warning("map '%s': can't determine value size for type [%u]: %lld=
.\n",
> +					   map_name, t->type, sz);
> +				return sz;
> +			}
> +			pr_debug("map '%s': found value [%u], sz =3D %lld.\n",
> +				 map_name, t->type, sz);
> +			if (map->def.value_size && map->def.value_size !=3D sz) {
> +				pr_warning("map '%s': conflictling value size %u !=3D %lld.\n",
> +					   map_name, map->def.value_size, sz);
> +				return -EINVAL;
> +			}
> +			map->def.value_size =3D sz;
> +			map->btf_value_type_id =3D t->type;
> +		} else {
> +			if (strict) {
> +				pr_warning("map '%s': unknown field '%s'.\n",
> +					   map_name, name);
> +				return -ENOTSUP;
> +			}
> +			pr_debug("map '%s': ignoring unknown field '%s'.\n",
> +				 map_name, name);
> +		}
> +	}
> +
> +	if (map->def.type =3D=3D BPF_MAP_TYPE_UNSPEC) {
> +		pr_warning("map '%s': map type isn't specified.\n", map_name);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int bpf_object__init_user_btf_maps(struct bpf_object *obj, bool s=
trict)
> +{
> +	const struct btf_type *sec =3D NULL;
> +	int nr_types, i, vlen, err;
> +	const struct btf_type *t;
> +	const char *name;
> +	Elf_Data *data;
> +	Elf_Scn *scn;
> +
> +	if (obj->efile.btf_maps_shndx < 0)
> +		return 0;
> +
> +	scn =3D elf_getscn(obj->efile.elf, obj->efile.btf_maps_shndx);
> +	if (scn)
> +		data =3D elf_getdata(scn, NULL);
> +	if (!scn || !data) {
> +		pr_warning("failed to get Elf_Data from map section %d (%s)\n",
> +			   obj->efile.maps_shndx, MAPS_ELF_SEC);
> +		return -EINVAL;
> +	}
> +
> +	nr_types =3D btf__get_nr_types(obj->btf);
> +	for (i =3D 1; i <=3D nr_types; i++) {
> +		t =3D btf__type_by_id(obj->btf, i);
> +		if (BTF_INFO_KIND(t->info) !=3D BTF_KIND_DATASEC)
> +			continue;
> +		name =3D btf__name_by_offset(obj->btf, t->name_off);
> +		if (strcmp(name, MAPS_ELF_SEC) =3D=3D 0) {
> +			sec =3D t;
> +			break;
> +		}
> +	}
> +
> +	if (!sec) {
> +		pr_warning("DATASEC '%s' not found.\n", MAPS_ELF_SEC);
> +		return -ENOENT;
> +	}
> +
> +	vlen =3D BTF_INFO_VLEN(sec->info);
> +	for (i =3D 0; i < vlen; i++) {
> +		err =3D bpf_object__init_user_btf_map(obj, sec, i,
> +						    obj->efile.btf_maps_shndx,
> +						    data, strict);
> +		if (err)
> +			return err;
> +	}
> +
> +	return 0;
> +}
> +
> static int bpf_object__init_maps(struct bpf_object *obj, int flags)
> {
> 	bool strict =3D !(flags & MAPS_RELAX_COMPAT);
> @@ -1016,6 +1324,10 @@ static int bpf_object__init_maps(struct bpf_object=
 *obj, int flags)
> 	if (err)
> 		return err;
>=20
> +	err =3D bpf_object__init_user_btf_maps(obj, strict);
> +	if (err)
> +		return err;
> +
> 	err =3D bpf_object__init_global_data_maps(obj);
> 	if (err)
> 		return err;
> @@ -1113,10 +1425,16 @@ static void bpf_object__sanitize_btf_ext(struct b=
pf_object *obj)
> 	}
> }
>=20
> +static bool bpf_object__is_btf_mandatory(const struct bpf_object *obj)
> +{
> +	return obj->efile.btf_maps_shndx >=3D 0;
> +}
> +
> static int bpf_object__init_btf(struct bpf_object *obj,
> 				Elf_Data *btf_data,
> 				Elf_Data *btf_ext_data)
> {
> +	bool btf_required =3D bpf_object__is_btf_mandatory(obj);
> 	int err =3D 0;
>=20
> 	if (btf_data) {
> @@ -1150,10 +1468,18 @@ static int bpf_object__init_btf(struct bpf_object=
 *obj,
> 	}
> out:
> 	if (err || IS_ERR(obj->btf)) {
> +		if (btf_required)
> +			err =3D err ? : PTR_ERR(obj->btf);
> +		else
> +			err =3D 0;
> 		if (!IS_ERR_OR_NULL(obj->btf))
> 			btf__free(obj->btf);
> 		obj->btf =3D NULL;
> 	}
> +	if (btf_required && !obj->btf) {
> +		pr_warning("BTF is required, but is missing or corrupted.\n");
> +		return err =3D=3D 0 ? -ENOENT : err;
> +	}
> 	return 0;
> }
>=20
> @@ -1173,6 +1499,8 @@ static int bpf_object__sanitize_and_load_btf(struct=
 bpf_object *obj)
> 			   BTF_ELF_SEC, err);
> 		btf__free(obj->btf);
> 		obj->btf =3D NULL;
> +		if (bpf_object__is_btf_mandatory(obj))
> +			return err;
> 	}
> 	return 0;
> }
> @@ -1236,6 +1564,8 @@ static int bpf_object__elf_collect(struct bpf_objec=
t *obj, int flags)
> 				return err;
> 		} else if (strcmp(name, "maps") =3D=3D 0) {
> 			obj->efile.maps_shndx =3D idx;
> +		} else if (strcmp(name, MAPS_ELF_SEC) =3D=3D 0) {
> +			obj->efile.btf_maps_shndx =3D idx;
> 		} else if (strcmp(name, BTF_ELF_SEC) =3D=3D 0) {
> 			btf_data =3D data;
> 		} else if (strcmp(name, BTF_EXT_ELF_SEC) =3D=3D 0) {
> @@ -1355,7 +1685,8 @@ static bool bpf_object__shndx_is_data(const struct =
bpf_object *obj,
> static bool bpf_object__shndx_is_maps(const struct bpf_object *obj,
> 				      int shndx)
> {
> -	return shndx =3D=3D obj->efile.maps_shndx;
> +	return shndx =3D=3D obj->efile.maps_shndx ||
> +	       shndx =3D=3D obj->efile.btf_maps_shndx;
> }
>=20
> static bool bpf_object__relo_in_known_section(const struct bpf_object *ob=
j,
> @@ -1399,14 +1730,14 @@ bpf_program__collect_reloc(struct bpf_program *pr=
og, GElf_Shdr *shdr,
> 	prog->nr_reloc =3D nrels;
>=20
> 	for (i =3D 0; i < nrels; i++) {
> -		GElf_Sym sym;
> -		GElf_Rel rel;
> -		unsigned int insn_idx;
> -		unsigned int shdr_idx;
> 		struct bpf_insn *insns =3D prog->insns;
> 		enum libbpf_map_type type;
> +		unsigned int insn_idx;
> +		unsigned int shdr_idx;
> 		const char *name;
> 		size_t map_idx;
> +		GElf_Sym sym;
> +		GElf_Rel rel;
>=20
> 		if (!gelf_getrel(data, i, &rel)) {
> 			pr_warning("relocation: failed to get %d reloc\n", i);
> @@ -1500,14 +1831,18 @@ bpf_program__collect_reloc(struct bpf_program *pr=
og, GElf_Shdr *shdr,
> 	return 0;
> }
>=20
> -static int bpf_map_find_btf_info(struct bpf_map *map, const struct btf *=
btf)
> +static int bpf_map_find_btf_info(struct bpf_object *obj, struct bpf_map =
*map)
> {
> 	struct bpf_map_def *def =3D &map->def;
> 	__u32 key_type_id =3D 0, value_type_id =3D 0;
> 	int ret;
>=20
> +	/* if it's BTF-defined map, we don't need to search for type IDs */
> +	if (map->sec_idx =3D=3D obj->efile.btf_maps_shndx)
> +		return 0;
> +
> 	if (!bpf_map__is_internal(map)) {
> -		ret =3D btf__get_map_kv_tids(btf, map->name, def->key_size,
> +		ret =3D btf__get_map_kv_tids(obj->btf, map->name, def->key_size,
> 					   def->value_size, &key_type_id,
> 					   &value_type_id);
> 	} else {
> @@ -1515,7 +1850,7 @@ static int bpf_map_find_btf_info(struct bpf_map *ma=
p, const struct btf *btf)
> 		 * LLVM annotates global data differently in BTF, that is,
> 		 * only as '.data', '.bss' or '.rodata'.
> 		 */
> -		ret =3D btf__find_by_name(btf,
> +		ret =3D btf__find_by_name(obj->btf,
> 				libbpf_type_to_btf_name[map->libbpf_type]);
> 	}
> 	if (ret < 0)
> @@ -1805,7 +2140,7 @@ bpf_object__create_maps(struct bpf_object *obj)
> 		    map->inner_map_fd >=3D 0)
> 			create_attr.inner_map_fd =3D map->inner_map_fd;
>=20
> -		if (obj->btf && !bpf_map_find_btf_info(map, obj->btf)) {
> +		if (obj->btf && !bpf_map_find_btf_info(obj, map)) {
> 			create_attr.btf_fd =3D btf__fd(obj->btf);
> 			create_attr.btf_key_type_id =3D map->btf_key_type_id;
> 			create_attr.btf_value_type_id =3D map->btf_value_type_id;
> --=20
> 2.17.1
>=20

